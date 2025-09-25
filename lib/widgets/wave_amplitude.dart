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
        numChannels: 1,
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
    // Не пушим нули — UI хранит последний кадр сам.
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
    this.maxBurstsPerLayer = 10,

    // === генерация случайных точек (seed) на тик ===
    this.seedsPerTickMin = 6,
    this.seedsPerTickMax = 10,
    this.seedMinGap = 28.0, // минимальный зазор между точками, px
    this.humpHalfWidthPxMin = 24.0, // половина ширины «горба» (минимум), px
    this.humpHalfWidthPxMax = 72.0, // половина ширины «горба» (максимум), px

    // === «анти-обрезание» по краям ===
    this.edgePadding = 0.001, // гарантированный запас внутри холста, px
    this.edgeFadePx = 0, // ширина мягкого фейда у краёв; 0 — отключить

    // === контейнер ===
    this.backgroundColor = Colors.transparent,
    this.containerShadow = const BoxShadow(
      color: Color.fromRGBO(48, 51, 212, 0.25),
      blurRadius: 120,
      offset: Offset(0, 20),
    ),
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

  // анти-обрезание
  final double edgePadding;
  final double edgeFadePx;

  // оформление контейнера
  final Color backgroundColor;
  final BoxShadow containerShadow;

  @override
  State<WaveAmplitude> createState() => _WaveAmplitudeState();
}

class _WaveAmplitudeState extends State<WaveAmplitude>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  static const _eps = 1e-4;

  final _rnd = math.Random();
  final _mic = MicAmplitudeService();

  Timer? _timer;
  Size _lastSize = Size.zero;

  TriBandLevel _bands = const TriBandLevel(0, 0, 0);
  final List<_WaveBurst> _bursts = [];
  StreamSubscription<TriBandLevel>? _micSub;

  bool _disposed = false;
  bool _suspended = false;
  bool _fadingOut = false;

  final _layers = <_LayerCfg>[
    const _LayerCfg(band: _Band.low, ampMul: 1.15, z: 0),
    const _LayerCfg(band: _Band.mid, ampMul: 0.90, z: 1),
    const _LayerCfg(band: _Band.high, ampMul: 0.75, z: 2),
  ];

  // ---------- helpers ----------

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

  double _nudge(double v) => v.clamp(_eps, 1.0 - _eps);

  void _resumeBurst(_WaveBurst b) {
    if (b.isDisposed) return;

    double from = _nudge((b.frozenValue ?? b.ctrl.value).clamp(0.0, 1.0));
    int dir = b.frozenDir ?? b.lastDir;

    if (from >= 1.0 - _eps && dir >= 0) dir = -1;
    if (from <= _eps && dir <= 0) dir = 1;

    b.ctrl.value = from;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _suspended || b.isDisposed) return;
      if (dir >= 0) {
        b.ctrl.forward(from: from);
      } else {
        b.ctrl.reverse(from: from);
      }
    });

    b.frozenValue = null;
    b.frozenDir = null;
  }

  Future<void> _fadeOut() async {
    // включаем режим затухания: не спавнить новые
    _fadingOut = true;

    // Останавливаем расписание и микрофон, но НЕ стопаем контроллеры.
    _timer?.cancel();
    _timer = null;
    await _micSub?.cancel();
    _micSub = null;
    await _mic.stop();

    // Каждую живую волну мягко "уводим" вниз
    for (final b in _bursts) {
      if (b.isDisposed) continue;
      final from =
          (((b.ctrl.value.isNaN ? 0.0 : b.ctrl.value))).clamp(0.0, 1.0);
      // если уже в нуле — ничего
      if (from > 0.0) {
        b.ctrl.reverse(from: from);
      }
    }

    // принудительно перерисуемся
    _safeSetState(() {});
  }

  // ---------- lifecycle ----------

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
      widget.isActive ? _resume() : _fadeOut();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _timer = null;

    for (final b in List<_WaveBurst>.from(_bursts)) {
      if (!b.isDisposed) {
        b.isDisposed = true;
        b.ctrl.stop();
        b.ctrl.dispose();
      }
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

    for (final b in _bursts) {
      if (b.isDisposed) continue;
      b.frozenValue = b.ctrl.value;
      b.frozenDir = b.lastDir;
      b.ctrl.stop(canceled: false);
    }
  }

  Future<void> _resume() async {
    if (!_suspended && _micSub != null) return;
    _suspended = false;
    _fadingOut = false;
    if (!widget.isActive) return;

    await _startMic();

    for (final b in _bursts) {
      _resumeBurst(b);
    }

    if (_lastSize.width > 0 && _timer == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_suspended && _timer == null) _startScheduling();
      });
    }

    _safeSetState(() {});
  }

  // ---------- mic / schedule ----------

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

  List<double> _randomSeeds({
    required double width,
    required int target,
    required double minGap,
    required double edgePad, // NEW: не генерим у краёв
  }) {
    final xs = <double>[];
    if (width <= 0 || target <= 0) return xs;
    final left = edgePad.clamp(0.0, width / 2);
    final right = width - left;
    int attempts = 0;
    final maxAttempts = target * 30;
    while (xs.length < target && attempts < maxAttempts) {
      attempts++;
      final x = left + _rnd.nextDouble() * (right - left);
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
    if (_fadingOut) return;

    const hardMaxBursts = 90;
    if (_bursts.length >= hardMaxBursts) return;

    final seedsTarget =
        _rnd.nextInt((widget.seedsPerTickMax - widget.seedsPerTickMin + 1)) +
            widget.seedsPerTickMin;

    final seeds = _randomSeeds(
      width: _lastSize.width,
      target: seedsTarget,
      minGap: widget.seedMinGap,
      edgePad: widget.edgePadding, // NEW
    );

    final availableXs = List<double>.from(seeds)..shuffle(_rnd);

    int alive(_Band band) =>
        _bursts.where((b) => b.band == band && !b.isDisposed).length;

    final layersOrdered = <_LayerCfg>[..._layers]
      ..sort((a, b) => a.z.compareTo(b.z));

    for (final layer in layersOrdered) {
      final level = switch (layer.band) {
        _Band.low => _bands.low,
        _Band.mid => _bands.mid,
        _Band.high => _bands.high,
      };

      if (level <= 0.03) continue;

      final already = alive(layer.band);
      if (already >= widget.maxBurstsPerLayer) continue;

      final base = (seeds.length / 2).ceil();
      final toStartRaw = (base * (0.6 + 0.8 * level)).round();
      final toStart = toStartRaw.clamp(
        widget.minBurstsPerLayer - already,
        widget.maxBurstsPerLayer - already,
      );
      if (toStart <= 0 || availableXs.isEmpty) continue;

      int started = 0;
      while (started < toStart && availableXs.isNotEmpty) {
        double centerX = availableXs.removeLast();

        final halfWidth = _lerp(
          widget.humpHalfWidthPxMin,
          widget.humpHalfWidthPxMax,
          _rnd.nextDouble(),
        );

        final ampRand = _lerp(0.85, 1.15, _rnd.nextDouble());
        final amp = (widget.maxAmplitude * layer.ampMul * level * ampRand)
            .clamp(0.0, widget.maxAmplitude * 1.3);

        final (fill, _) = switch (layer.band) {
          _Band.low => widget.lowColors,
          _Band.mid => widget.midColors,
          _Band.high => widget.highColors,
        };

        final durMS = _lerp(300, 650, _rnd.nextDouble()).toInt();
        final ctrl = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: durMS),
          animationBehavior: AnimationBehavior.preserve,
        );
        final anim = CurvedAnimation(parent: ctrl, curve: Curves.easeInOut);

        final burst = _WaveBurst(
          band: layer.band,
          z: layer.z,
          centerX: centerX,
          halfWidth: halfWidth,
          maxAmplitude: amp,
          color: fill,
          anim: anim,
          ctrl: ctrl,
        );

        ctrl.addListener(() {
          if (burst.isDisposed) return;
          final v = ctrl.value;
          if (v > burst.lastValue) {
            burst.lastDir = 1;
          } else if (v < burst.lastValue) {
            burst.lastDir = -1;
          }
          burst.lastValue = v;

          if (!_suspended) _safeSetState(() {});
        });

        ctrl.addStatusListener((st) {
          if (burst.isDisposed) return;
          if (st == AnimationStatus.completed) ctrl.reverse();
          if (st == AnimationStatus.dismissed) {
            burst.isDisposed = true;
            _bursts.remove(burst);
            ctrl.dispose();
            if (_fadingOut && _bursts.every((b) => b.isDisposed)) {
              _fadingOut = false;
            }

            if (mounted && !_suspended) _safeSetState(() {});
          }
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

      final hasWaves = _bursts.any((b) => !b.isDisposed);

// Целевая непрозрачность тени (0..1)
      final baseAlpha = widget.containerShadow.color.opacity;
      final targetAlpha = baseAlpha * (hasWaves ? 1.0 : 0.0);

// Та же тень, но с анимируемой альфой
      final fadingShadow = widget.containerShadow.copyWith(
        color: widget.containerShadow.color.withOpacity(targetAlpha),
      );

      return AnimatedContainer(
        duration:
            const Duration(milliseconds: 300), // можно увеличить до 300–400ms
        curve: Curves.easeOut, // или Curves.easeOutCubic
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          boxShadow: [fadingShadow], // <-- всегда один BoxShadow
        ),
        child: SizedBox(
          width: c.maxWidth,
          height: widget.height,
          child: CustomPaint(
            painter: _ReactivePainter(
              size: _lastSize,
              bursts: _bursts,
              edgeFadePx: widget.edgeFadePx,
            ),
          ),
        ),
      );
    });
  }
}

/// ===== Painter =====

class _ReactivePainter extends CustomPainter {
  _ReactivePainter({
    required this.size,
    required this.bursts,
    required this.edgeFadePx,
  });

  final Size size;
  final List<_WaveBurst> bursts;
  final double edgeFadePx; // 0 => без фейда

  @override
  void paint(Canvas canvas, Size _) {
    final items = bursts.where((b) => !b.isDisposed).toList()
      ..sort((a, b) => a.z.compareTo(b.z));

    for (final b in items) {
      final ampBase = b.maxAmplitude * b.anim.value;
      if (ampBase <= 0.1 || b.halfWidth <= 1) continue;

      final baseY = size.height;
      final startX = b.centerX - b.halfWidth;
      final endX = b.centerX + b.halfWidth;

// Полностью вне экрана — ничего не рисуем
      if (endX <= 0 || startX >= size.width) return;

      final path = Path();
      const step = 4.0;
      final xMin = math.max(0.0, startX);
      final xMax = math.min(endX, size.width);

// 1) Левый край: если волна заходит влево — рисуем вертикальный срез
      if (startX < 0) {
        final t0 = ((0.0 - startX) / (2 * b.halfWidth)).clamp(0.0, 1.0);
        final w0 = 0.5 * (1.0 + math.cos(math.pi * (t0 * 2 - 1)));
        final y0 = baseY - ampBase * w0;
        path
          ..moveTo(0, baseY)
          ..lineTo(0, y0); // вертикальный «срез» слева
      } else {
        path.moveTo(startX, baseY);
      }

// 2) Центральная часть — без edgeFade, чистая форма горба
      for (double x = xMin; x <= xMax; x += step) {
        final t = ((x - startX) / (2 * b.halfWidth)).clamp(0.0, 1.0);
        final w = 0.5 * (1.0 + math.cos(math.pi * (t * 2 - 1)));
        final y = baseY - ampBase * w;
        path.lineTo(x, y);
      }

// 3) Правый край: если волна уходит за экран — вертикальный срез справа
      if (endX > size.width) {
        final t1 = ((size.width - startX) / (2 * b.halfWidth)).clamp(0.0, 1.0);
        final w1 = 0.5 * (1.0 + math.cos(math.pi * (t1 * 2 - 1)));
        final y1 = baseY - ampBase * w1;
        path
          ..lineTo(size.width, y1) // вертикальный «срез» справа
          ..lineTo(size.width, baseY);
      } else {
        path.lineTo(endX, baseY);
      }

      path.close();

      final paint = Paint()..color = b.color;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ReactivePainter old) =>
      old.bursts != bursts || old.size != size || old.edgeFadePx != edgeFadePx;
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
    required this.anim,
    required this.ctrl,
  });

  final _Band band;
  final int z;

  double centerX;
  final double halfWidth;
  final double maxAmplitude;

  final Color color;

  final Animation<double> anim;
  final AnimationController ctrl;

  // для восстановления анимации после возврата
  double lastValue = 0.0;
  int lastDir = 1; // +1 = forward, -1 = reverse
  double? frozenValue;
  int? frozenDir;

  // защита от use-after-dispose
  bool isDisposed = false;
}

/// утилита
double _lerp(num a, num b, double t) => a + (b - a) * t;
