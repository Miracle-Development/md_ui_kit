import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:record/record.dart';

/// -------------------------
/// Микро-сервис амплитуды
/// -------------------------
class MicAmplitudeService {
  final AudioRecorder _record = AudioRecorder();
  StreamSubscription<Amplitude>? _sub;
  final _controller = StreamController<double>.broadcast();
  Stream<double> get stream => _controller.stream;

  double _smooth = 0.0;

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

    _sub = _record
        .onAmplitudeChanged(const Duration(milliseconds: 80))
        .listen((amp) {
      final a = _dbTo01(amp.current);
      _smooth = 0.6 * _smooth + 0.4 * a;
      _controller.add(_smooth);
    });
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
    if (await _record.isRecording()) {
      await _record.stop();
    }
    _controller.add(0.0);
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

/// -------------------------
/// Виджет волн
/// -------------------------
class WaveAmplitude extends StatefulWidget {
  const WaveAmplitude({
    super.key,
    required this.isActive,
    this.maxAmplitude = 92.0,
    this.height = 92.0,
    this.minSlotWidth = 60.0,
    this.burstPeriod = const Duration(milliseconds: 220),
    this.palette = const [
      (Color.fromRGBO(67, 70, 243, 0.4), Color.fromRGBO(58, 51, 253, 0.25)),
      (Color.fromRGBO(48, 51, 212, 0.4), Color.fromRGBO(48, 51, 212, 0.25)),
      (Color.fromRGBO(140, 141, 227, 0.3), Color.fromRGBO(51, 169, 253, 0.25)),
    ],
  });

  final bool isActive;
  final double maxAmplitude;
  final double height;
  final double minSlotWidth;
  final Duration burstPeriod;
  final List<(Color fill, Color shadow)> palette;

  @override
  State<WaveAmplitude> createState() => _WaveAmplitudeState();
}

class _WaveAmplitudeState extends State<WaveAmplitude>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final _rnd = math.Random();
  final _mic = MicAmplitudeService();

  Timer? _timer;
  Size _lastSize = Size.zero;
  double _level = 0.0;
  final List<_WaveBurst> _bursts = [];
  StreamSubscription<double>? _micSub;

  bool _disposed = false;
  bool _suspended = false;

  // Безопасный setState: если мы внутри build/layout/paint — переносим на post-frame
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
      _level = 0.0;
    });
  }

  Future<void> _resume() async {
    if (!_suspended && _micSub != null) return;
    _suspended = false;
    if (!widget.isActive) return;

    await _startMic();
    if (_lastSize.width > 0 && _timer == null) {
      // запуск расписания после кадра, чтобы не попасть в build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_suspended && _timer == null) _startScheduling();
      });
    }
  }

  Future<void> _startMic() async {
    await _mic.start();
    await _micSub?.cancel();
    _micSub = _mic.stream.listen((a) {
      _level = a;
      if (_timer == null && _lastSize.width > 0 && !_suspended) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_suspended && _timer == null) _startScheduling();
        });
      }
    });
    // на случай, если размер уже известен
    if (_lastSize.width > 0 && !_suspended && _timer == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_suspended && _timer == null) _startScheduling();
      });
    }
  }

  void _startScheduling() {
    if (_suspended) return;
    _timer?.cancel();
    _tick(); // сразу
    _timer = Timer.periodic(widget.burstPeriod, (_) => _tick());
  }

  void _tick() {
    if (!mounted || _suspended || _lastSize.width <= 0) return;

    // предохранитель на случай сбоев: ограничим число активных анимаций
    const hardMaxBursts = 60;
    if (_bursts.length >= hardMaxBursts) return;

    // тишина — не спавним новые
    if (_level <= 0.03) return;

    final slotCount =
        math.max(1, (_lastSize.width / widget.minSlotWidth).floor());
    final toStart = math.max(1, (slotCount / 2).floor());

    final slots = List<int>.generate(slotCount, (i) => i)..shuffle(_rnd);

    for (int i = 0; i < toStart; i++) {
      final slot = slots[i];
      final centerX = (slot + 0.5) * (_lastSize.width / slotCount);
      final halfWidth =
          (_lastSize.width / slotCount) * _lerp(0.8, 1.2, _rnd.nextDouble());

      final ampRand = _lerp(0.85, 1.15, _rnd.nextDouble());
      final amp = (widget.maxAmplitude * _level * ampRand)
          .clamp(0.0, widget.maxAmplitude);

      final (fill, shadow) =
          widget.palette[_rnd.nextInt(widget.palette.length)];

      final durMS = _lerp(320, 680, _rnd.nextDouble()).toInt();
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durMS),
      );
      final anim = CurvedAnimation(parent: ctrl, curve: Curves.easeInOut);

      final burst = _WaveBurst(
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
    }

    _safeSetState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      _lastSize = Size(c.maxWidth, widget.height);

      // НЕ запускаем расписание прямо в build.
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

/// Отрисовка волн
class _ReactivePainter extends CustomPainter {
  _ReactivePainter({required this.size, required this.bursts});
  final Size size;
  final List<_WaveBurst> bursts;

  @override
  void paint(Canvas canvas, Size _) {
    for (final b in bursts) {
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

class _WaveBurst {
  _WaveBurst({
    required this.centerX,
    required this.halfWidth,
    required this.maxAmplitude,
    required this.color,
    required this.shadow,
    required this.anim,
    required this.ctrl,
  });

  final double centerX;
  final double halfWidth;
  final double maxAmplitude;
  final Color color;
  final Color shadow;
  final Animation<double> anim;
  final AnimationController ctrl;
}

double _lerp(num a, num b, double t) => a + (b - a) * t;
