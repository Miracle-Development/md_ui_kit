import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:record/record.dart';

// TODO: ASK PERMISSIONS FOR NATIVE PLATFORMS (ANDROID, IOS)

/// -------------------------
/// Микро-сервис амплитуды (общий для mobile/web/desktop)
/// -------------------------

class MicAmplitudeService {
  final AudioRecorder _record = AudioRecorder();
  StreamSubscription<Amplitude>? _sub;
  final _controller = StreamController<double>.broadcast();
  Stream<double> get stream => _controller.stream;

  double _smooth = 0.0;

  Future<void> start() async {
    // 1) Разрешение
    final ok = await _record.hasPermission();
    if (!ok) return;

    // 2) Старт «тихой» записи (файл нам не нужен)
    await _record.start(
      path: "null",
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 44100,
        numChannels: 1,
        bitRate: 128000,
      ),
    );

    // 3) Поток амплитуды
    _sub = _record
        .onAmplitudeChanged(const Duration(milliseconds: 80))
        .listen((Amplitude amp) {
      final a = _dbTo01(amp.current); // 0..1
      _smooth = 0.6 * _smooth + 0.4 * a; // сглаживание
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

  // dB (~[-60..0]) -> 0..1
  double _dbTo01(double db) {
    if (!db.isFinite) return 0.0;
    const minDb = -60.0;
    final d = db.clamp(minDb, 0.0);
    return ((d - minDb) / -minDb).clamp(0.0, 1.0);
  }
}

/// -------------------------
/// Виджет волн, реагирующий на громкость
/// -------------------------
class WaveAmplitude extends StatefulWidget {
  const WaveAmplitude({
    super.key,
    required this.isActive, // включает/выключает микрофон
    this.maxAmplitude = 92.0, // пиковая высота «шапки»
    this.height = 92.0, // высота холста
    this.minSlotWidth =
        120.0, // адаптивная сетка (чем меньше — тем больше «позиций»)
    this.burstPeriod = const Duration(
        milliseconds: 220), // как часто пробуем запустить «шапки»
    this.palette = const [
      // (заливка, тень)
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
    with TickerProviderStateMixin {
  final _rnd = math.Random();
  final _mic = MicAmplitudeService();
  bool _disposed = false;

  void _safeSetState(VoidCallback fn) {
    if (!_disposed || mounted) setState(fn);
  }

  Timer? _timer;
  Size _lastSize = Size.zero;
  double _level = 0.0; // 0..1 нормированная громкость

  // Активные волны (каждая — с собственным контроллером появления/исчезания)
  final List<_WaveBurst> _bursts = [];
  StreamSubscription<double>? _micSub;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) _startMic();
  }

  @override
  void didUpdateWidget(covariant WaveAmplitude old) {
    super.didUpdateWidget(old);
    if (old.isActive != widget.isActive) {
      if (widget.isActive) {
        _startMic();
      } else {
        _stopMic();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // планировщик
    _timer = null;

    // остановить/освободить все контроллеры волн
    for (final b in List<_WaveBurst>.from(_bursts)) {
      // снимаем слушатели, чтобы они не дернули setState после dispose
      b.ctrl.stop();
      b.ctrl.dispose();
    }
    _bursts.clear();

    _disposed = true; // <- только после чистки
    super.dispose();
  }

  Future<void> _startMic() async {
    await _mic.start();
    _micSub?.cancel();
    _micSub = _mic.stream.listen((a) {
      _level = a; // запоминаем текущую громкость 0..1
      // запуск «расписания» при первом валидном размере
      if (_timer == null && _lastSize.width > 0) {
        _startScheduling();
      }
    });
    _startScheduling(); // на случай, если размер уже известен
  }

  Future<void> _stopMic() async {
    await _micSub?.cancel();
    _micSub = null;
    await _mic.stop();
    _timer?.cancel();
    _timer = null;
    if (!mounted || _disposed) return;
    setState(() {
      _level =
          0.0; // заставим текущие волны плавно затухнуть (reverse в контроллерах)
    });
  }

  void _startScheduling() {
    _timer?.cancel();
    // первая попытка сразу
    _tick();
    _timer = Timer.periodic(widget.burstPeriod, (_) => _tick());
  }

  void _tick() {
    if (!mounted || _lastSize.width <= 0) return;

    // При тишине — не добавляем новые бусты (старые сами дойдут до нуля).
    if (_level <= 0.03) return;

    final slotCount =
        math.max(1, (_lastSize.width / widget.minSlotWidth).floor());
    final toStart = math.max(1, (slotCount / 2).floor());

    // случайные слоты
    final slots = List<int>.generate(slotCount, (i) => i)..shuffle(_rnd);

    for (int i = 0; i < toStart; i++) {
      final slot = slots[i];
      final centerX = (slot + 0.5) * (_lastSize.width / slotCount);
      final halfWidth =
          (_lastSize.width / slotCount) * _lerp(0.8, 1.2, _rnd.nextDouble());

      // высота зависит от уровня + немного случайности
      final ampRand = _lerp(0.85, 1.15, _rnd.nextDouble());
      final amp = (widget.maxAmplitude * _level * ampRand)
          .clamp(0.0, widget.maxAmplitude);

      final (fill, shadow) =
          widget.palette[_rnd.nextInt(widget.palette.length)];

      // индивидуальная длительность появления/затухания
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
          if (mounted) _safeSetState(() {}); // перерисовать без него
        }
      });

      ctrl.addListener(() => setState(() {}));
      _bursts.add(burst);
      ctrl.forward();
    }

    _safeSetState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      _lastSize = Size(c.maxWidth, widget.height);

      // если микрофон активен и ещё не крутится таймер — запустим
      if (widget.isActive && _timer == null) _startScheduling();

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

/// Рисуем независимые «шапки» (raised-cosine) с собственной тенью/цветом
class _ReactivePainter extends CustomPainter {
  _ReactivePainter({required this.size, required this.bursts});
  final Size size;
  final List<_WaveBurst> bursts;

  @override
  void paint(Canvas canvas, Size _) {
    for (final b in bursts) {
      final ampNow = b.maxAmplitude * b.anim.value;
      if (ampNow <= 0.1 || b.halfWidth <= 1) continue;

      final baseY = size.height; // «линия воды»
      final startX = (b.centerX - b.halfWidth).clamp(0.0, size.width);
      final endX = (b.centerX + b.halfWidth).clamp(0.0, size.width);
      if (endX <= startX) continue;

      final path = Path()..moveTo(startX, baseY);

      // Raised-cosine: гладкий колокол (похожа на параболу/полусинус)
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

      // Тень (смещение + сильный blur)
      final shadowPaint = Paint()
        ..color = b.shadow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120);
      canvas.save();
      canvas.translate(0, 20);
      canvas.drawPath(path, shadowPaint);
      canvas.restore();

      // Заливка
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

// утилита
double _lerp(num a, num b, double t) => a + (b - a) * t;
