import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:record/record.dart';

/// =========================
///  MIC SERVICE (tri-band)
/// =========================

class TriBandLevel {
  const TriBandLevel(this.low, this.mid, this.high);
  final double low; // «бас» (медленная огибающая)
  final double mid; // «середина»
  final double high; // «вч» (быстрая огибающая)
}

class MicAmplitudeService {
  final AudioRecorder _record = AudioRecorder();
  StreamSubscription<Amplitude>? _sub;

  final _controller = StreamController<TriBandLevel>.broadcast();
  Stream<TriBandLevel> get stream => _controller.stream;

  double _base = 0.0;
  double _low = 0.0, _mid = 0.0, _high = 0.0;

  static const _samplePeriod = Duration(milliseconds: 80);
  static const _tauLow = 0.60; // сек
  static const _tauMid = 0.25; // сек
  static const _tauHigh = 0.10; // сек

  double _alpha(double tauSec) {
    final dt = _samplePeriod.inMilliseconds / 1000.0;
    return 1.0 - math.exp(-dt / tauSec);
  }

  Future<void> start() async {
    final ok = await _record.hasPermission();
    if (!ok) return;

    await _record.start(
      path: "null",
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 44100,
        numChannels: 1,
        bitRate: 128000,
      ),
    );

    final aLow = _alpha(_tauLow);
    final aMid = _alpha(_tauMid);
    final aHigh = _alpha(_tauHigh);

    _sub = _record.onAmplitudeChanged(_samplePeriod).listen((amp) {
      _base = _dbTo01(amp.current); // 0..1
      _low = _low + aLow * (_base - _low);
      _mid = _mid + aMid * (_base - _mid);
      _high = _high + aHigh * (_base - _high);
      _controller.add(TriBandLevel(_low, _mid, _high));
    });
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
    if (await _record.isRecording()) {
      await _record.stop();
    }
    _base = _low = _mid = _high = 0.0;
    _controller.add(const TriBandLevel(0, 0, 0));
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }

  double _dbTo01(double db) {
    if (!db.isFinite) return 0.0;
    const minDb = -60.0;
    final d = db.clamp(minDb, 0.0);
    return ((d - minDb) / -minDb).clamp(0.0, 1.0);
  }
}

/// =========================
///  WIDGET (tri-layer waves)
/// =========================

class WaveAmplitude extends StatefulWidget {
  const WaveAmplitude({
    super.key,
    required this.isActive,
    this.height = 92.0,
    this.maxAmplitude = 92.0,
    this.burstPeriod = const Duration(milliseconds: 220),

    // Порядок — задний, средний, передний (низкие, средние, высокие):
    this.lowColors = const (
      Color.fromRGBO(48, 51, 212, 0.40),
      Color.fromRGBO(48, 51, 212, 0.25)
    ),
    this.midColors = const (
      Color.fromRGBO(67, 70, 243, 0.40),
      Color.fromRGBO(58, 51, 253, 0.25)
    ),
    this.highColors = const (
      Color.fromRGBO(140, 141, 227, 0.30),
      Color.fromRGBO(51, 169, 253, 0.25)
    ),

    // Минимум/максимум активных волн на слой
    this.minBurstsPerLayer = 0,
    this.maxBurstsPerLayer = 20,

    // === генерация случайных точек (seed) на тик ===
    this.seedsPerTickMin = 6,
    this.seedsPerTickMax = 10,
    this.seedMinGap = 28.0, // минимальный зазор между точками, px
    this.humpHalfWidthPxMin = 24.0, // половина ширины «горба» (минимум), px
    this.humpHalfWidthPxMax = 72.0, // половина ширины «горба» (максимум), px
  });

  final bool isActive;
  final double height;
  final double maxAmplitude;
  final Duration burstPeriod;

  final (Color fill, Color shadow) lowColors;
  final (Color fill, Color shadow) midColors;
  final (Color fill, Color shadow) highColors;

  final int minBurstsPerLayer;
  final int maxBurstsPerLayer;

  // случайные точки появления
  final int seedsPerTickMin;
  final int seedsPerTickMax;
  final double seedMinGap;
  final double humpHalfWidthPxMin;
  final double humpHalfWidthPxMax;

  @override
  State<WaveAmplitude> createState() => _WaveAmplitudeState();
}

class _WaveAmplitudeState extends State<WaveAmplitude>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final _rnd = math.Random();
  final _mic = MicAmplitudeService();

  Timer? _timer;
  Size _lastSize = Size.zero;

  TriBandLevel _bands = const TriBandLevel(0, 0, 0);
  final List<_WaveBurst> _bursts = [];
  StreamSubscription<TriBandLevel>? _micSub;

  bool _disposed = false;
  bool _suspended = false;

  final _layers = <_LayerCfg>[
    _LayerCfg(band: _Band.low, ampMul: 1.15, z: 0), // задний — выше
    _LayerCfg(band: _Band.mid, ampMul: 0.90, z: 1),
    _LayerCfg(band: _Band.high, ampMul: 0.75, z: 2), // передний — ниже
  ];

  void _safeSetState(VoidCallback fn) {
    if (_disposed || !mounted) return;
    final phase = SchedulerBinding.instance.schedulerPhase;
    final canNow = phase == SchedulerPhase.idle ||
        phase == SchedulerPhase.postFrameCallbacks;
    if (canNow) {
      setState(fn);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_disposed && mounted) setState(fn);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.isActive) _startMic();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _resume();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _suspend();
        break;
    }
  }

  @override
  void didUpdateWidget(covariant WaveAmplitude oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      widget.isActive ? _resume() : _suspend();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _timer = null;

    for (final b in List<_WaveBurst>.from(_bursts)) {
      b.ctrl.stop();
      b.ctrl.dispose();
    }
    _bursts.clear();

    _micSub?.cancel();
    _mic.stop();

    _disposed = true;
    super.dispose();
  }

  Future<void> _suspend() async {
    if (_suspended) return;
    _suspended = true;

    _timer?.cancel();
    _timer = null;
    await _micSub?.cancel();
    _micSub = null;
    await _mic.stop();

    _safeSetState(() {
      for (final b in _bursts) {
        b.ctrl.stop();
        b.ctrl.dispose();
      }
      _bursts.clear();
      _bands = const TriBandLevel(0, 0, 0);
    });
  }

  Future<void> _resume() async {
    if (!_suspended && _micSub != null) return;
    _suspended = false;
    if (!widget.isActive) return;

    await _startMic();
    if (_lastSize.width > 0 && _timer == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_suspended && _timer == null) _startScheduling();
      });
    }
  }

  Future<void> _startMic() async {
    await _mic.start();
    await _micSub?.cancel();
    _micSub = _mic.stream.listen((bands) {
      _bands = bands;
      if (_timer == null && _lastSize.width > 0 && !_suspended) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_suspended && _timer == null) _startScheduling();
        });
      }
    });

    if (_lastSize.width > 0 && !_suspended && _timer == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_suspended && _timer == null) _startScheduling();
      });
    }
  }

  void _startScheduling() {
    if (_suspended) return;
    _timer?.cancel();
    _tick();
    _timer = Timer.periodic(widget.burstPeriod, (_) => _tick());
  }

  // сгенерировать случайный набор X с минимальным зазором
  List<double> _randomSeeds({
    required double width,
    required int target,
    required double minGap,
  }) {
    final xs = <double>[];
    if (width <= 0 || target <= 0) return xs;

    int attempts = 0;
    final maxAttempts = target * 30;
    while (xs.length < target && attempts < maxAttempts) {
      attempts++;
      final x = _rnd.nextDouble() * width;
      bool ok = true;
      for (final s in xs) {
        if ((s - x).abs() < minGap) {
          ok = false;
          break;
        }
      }
      if (ok) xs.add(x);
    }
    xs.sort();
    return xs;
  }

  void _tick() {
    if (!mounted || _suspended || _lastSize.width <= 0) return;

    // предохранитель
    const hardMaxBursts = 90;
    if (_bursts.length >= hardMaxBursts) return;

    // случайное количество «кандидатных» X-точек для ЭТОГО тика
    final seedsTarget =
        _rnd.nextInt((widget.seedsPerTickMax - widget.seedsPerTickMin + 1)) +
            widget.seedsPerTickMin;

    // набор уникальных X с минимальным зазором
    final seeds = _randomSeeds(
      width: _lastSize.width,
      target: seedsTarget,
      minGap: widget.seedMinGap,
    );

    // вспомогательный пул доступных точек (чтобы не дублировать X в разные слои)
    final availableXs = List<double>.from(seeds)..shuffle(_rnd);

    int alive(_Band band) => _bursts.where((b) => b.band == band).length;

    final layersOrdered = List<_LayerCfg>.from(_layers)
      ..sort((a, b) => a.z.compareTo(b.z));

    for (final layer in layersOrdered) {
      // текущий «уровень» для слоя
      final level = switch (layer.band) {
        _Band.low => _bands.low,
        _Band.mid => _bands.mid,
        _Band.high => _bands.high,
      };

      if (level <= 0.03) continue;

      final already = alive(layer.band);
      if (already >= widget.maxBurstsPerLayer) continue;

      // базовое кол-во стартов — пропорционально числу seeds и уровню
      final base = (seeds.length / 2).ceil();
      final toStartRaw = (base * (0.6 + 0.8 * level)).round();
      final toStart = toStartRaw.clamp(
        widget.minBurstsPerLayer - already,
        widget.maxBurstsPerLayer - already,
      );
      if (toStart <= 0 || availableXs.isEmpty) continue;

      int started = 0;
      while (started < toStart && availableXs.isNotEmpty) {
        final centerX = availableXs.removeLast();

        final halfWidth = _lerp(
          widget.humpHalfWidthPxMin,
          widget.humpHalfWidthPxMax,
          _rnd.nextDouble(),
        );

        final ampRand = _lerp(0.85, 1.15, _rnd.nextDouble());
        final amp = (widget.maxAmplitude * layer.ampMul * level * ampRand)
            .clamp(0.0, widget.maxAmplitude * 1.3);

        final (fill, shadow) = switch (layer.band) {
          _Band.low => widget.lowColors,
          _Band.mid => widget.midColors,
          _Band.high => widget.highColors,
        };

        final durMS = _lerp(300, 650, _rnd.nextDouble()).toInt();
        final ctrl = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: durMS),
        );
        final anim = CurvedAnimation(parent: ctrl, curve: Curves.easeInOut);

        final burst = _WaveBurst(
          band: layer.band,
          z: layer.z,
          centerX: centerX,
          halfWidth: halfWidth,
          maxAmplitude: amp,
          color: fill,
          shadow: shadow,
          anim: anim,
          ctrl: ctrl,
        );

        ctrl.addStatusListener((st) {
          if (st == AnimationStatus.completed) ctrl.reverse();
          if (st == AnimationStatus.dismissed) {
            burst.ctrl.dispose();
            _bursts.remove(burst);
            if (mounted && !_suspended) _safeSetState(() {});
          }
        });

        ctrl.addListener(() {
          if (!_suspended) _safeSetState(() {});
        });

        _bursts.add(burst);
        ctrl.forward();
        started++;
      }
    }

    _safeSetState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      _lastSize = Size(c.maxWidth, widget.height);

      if (widget.isActive && !_suspended && _timer == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_suspended && _timer == null) _startScheduling();
        });
      }

      return SizedBox(
        width: c.maxWidth,
        height: widget.height,
        child: CustomPaint(
          painter: _ReactivePainter(size: _lastSize, bursts: _bursts),
        ),
      );
    });
  }
}

/// ===== Painter =====

class _ReactivePainter extends CustomPainter {
  _ReactivePainter({required this.size, required this.bursts});
  final Size size;
  final List<_WaveBurst> bursts;

  @override
  void paint(Canvas canvas, Size _) {
    final items = List<_WaveBurst>.from(bursts)
      ..sort((a, b) => a.z.compareTo(b.z));

    for (final b in items) {
      final ampNow = b.maxAmplitude * b.anim.value;
      if (ampNow <= 0.1 || b.halfWidth <= 1) continue;

      final baseY = size.height;
      final startX = (b.centerX - b.halfWidth).clamp(0.0, size.width);
      final endX = (b.centerX + b.halfWidth).clamp(0.0, size.width);
      if (endX <= startX) continue;

      final path = Path()..moveTo(startX, baseY);

      const step = 4.0;
      for (double x = startX; x <= endX; x += step) {
        final t = ((x - (b.centerX - b.halfWidth)) / (2 * b.halfWidth))
            .clamp(0.0, 1.0);
        final window = 0.5 * (1.0 + math.cos(math.pi * (t * 2 - 1)));
        final y = baseY - ampNow * window;
        path.lineTo(x, y);
      }
      path
        ..lineTo(endX, baseY)
        ..close();

      final shadowPaint = Paint()
        ..color = b.shadow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120);
      canvas.save();
      canvas.translate(0, 20);
      canvas.drawPath(path, shadowPaint);
      canvas.restore();

      final paint = Paint()..color = b.color;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ReactivePainter old) =>
      old.bursts != bursts || old.size != size;
}

/// ===== Models =====

enum _Band { low, mid, high }

class _LayerCfg {
  const _LayerCfg({required this.band, required this.ampMul, required this.z});
  final _Band band;
  final double ampMul; // множитель высоты для слоя
  final int z; // порядок рисования (0 — задник)
}

class _WaveBurst {
  _WaveBurst({
    required this.band,
    required this.z,
    required this.centerX,
    required this.halfWidth,
    required this.maxAmplitude,
    required this.color,
    required this.shadow,
    required this.anim,
    required this.ctrl,
  });

  final _Band band;
  final int z;

  final double centerX;
  final double halfWidth;
  final double maxAmplitude;

  final Color color;
  final Color shadow;
  final Animation<double> anim;
  final AnimationController ctrl;
}

/// утилита
double _lerp(num a, num b, double t) => a + (b - a) * t;
