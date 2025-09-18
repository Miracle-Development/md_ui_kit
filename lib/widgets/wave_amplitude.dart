import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class WaveAmplitude extends StatefulWidget {
  const WaveAmplitude({
    super.key,
    required this.isActive,
    this.maxAmplitude = 92.0,
    this.frequency = 2.0,
    this.height = 92.0,
    this.minSlotWidth = 120.0, // адаптивная сетка по ширине
    this.burstPeriod = const Duration(milliseconds: 1000),
    // Палитра (цвет волны, цвет тени)
    this.palette = const [
      (Color.fromRGBO(67, 70, 243, 0.4), Color.fromRGBO(58, 51, 253, 0.25)),
      (Color.fromRGBO(48, 51, 212, 0.4), Color.fromRGBO(48, 51, 212, 0.25)),
      (Color.fromRGBO(140, 141, 227, 0.3), Color.fromRGBO(51, 169, 253, 0.25)),
    ],
  });

  final bool isActive;
  final double maxAmplitude; // до 92
  final double frequency; // 2
  final double height; // высота виджета (удобный контейнер)
  final double minSlotWidth; // чем меньше — тем больше потенциальных волн
  final Duration burstPeriod;
  final List<(Color fill, Color shadow)> palette;

  @override
  State<WaveAmplitude> createState() => _WaveAmplitudeState();
}

class _WaveAmplitudeState extends State<WaveAmplitude>
    with TickerProviderStateMixin {
  final _rnd = math.Random();
  Timer? _timer;
  Size _lastSize = Size.zero;

  // Активные «шапки» (волны), каждая со своим контроллером
  final List<_WaveBurst> _bursts = [];

  @override
  void initState() {
    super.initState();
    if (widget.isActive) _startScheduling();
  }

  @override
  void didUpdateWidget(covariant WaveAmplitude oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        _startScheduling();
      } else {
        _timer?.cancel(); // не запускаем новые, текущие дотухают
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final b in _bursts) {
      b.ctrl.dispose();
    }
    super.dispose();
  }

  void _startScheduling() {
    _timer?.cancel();
    _scheduleBurst(); // мгновенно
    _timer = Timer.periodic(widget.burstPeriod, (_) => _scheduleBurst());
  }

  void _scheduleBurst() {
    if (!mounted || _lastSize.width <= 0) return;

    final slotCount =
        math.max(1, (_lastSize.width / widget.minSlotWidth).floor());
    final toStart = math.max(1, (slotCount / 2).floor()); // n/2 волн

    // выбираем случайные центры (слоты) и стартуем волны
    final slots = List<int>.generate(slotCount, (i) => i)..shuffle(_rnd);
    for (int i = 0; i < toStart; i++) {
      final slot = slots[i];
      final centerX = (slot + 0.5) * (_lastSize.width / slotCount);
      final halfWidth =
          (_lastSize.width / slotCount) * _lerp(0.8, 1.2, _rnd.nextDouble());
      final amp = _lerp(
          widget.maxAmplitude * 0.35, widget.maxAmplitude, _rnd.nextDouble());

      final (fill, shadow) =
          widget.palette[_rnd.nextInt(widget.palette.length)];

      // лёгкая «индивидуальность» длительности
      final durMS = _lerp(900, 1600, _rnd.nextDouble()).toInt();
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

      // когда дошли до конца — пошли назад (затухаем), затем удаляем
      ctrl.addStatusListener((st) {
        if (st == AnimationStatus.completed) ctrl.reverse();
        if (st == AnimationStatus.dismissed) {
          // убрать из списка и освободить контроллер
          burst.ctrl.dispose();
          _bursts.remove(burst);
          if (mounted) setState(() {});
        }
      });

      ctrl.addListener(() => setState(() {}));
      _bursts.add(burst);
      ctrl.forward();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _lastSize = Size(constraints.maxWidth, widget.height);

      return SizedBox(
        width: constraints.maxWidth,
        height: widget.height,
        child: CustomPaint(
          painter: _ReactivePainter(
            size: _lastSize,
            bursts: _bursts,
          ),
        ),
      );
    });
  }
}

class _ReactivePainter extends CustomPainter {
  _ReactivePainter({required this.size, required this.bursts});
  final Size size;
  final List<_WaveBurst> bursts;

  @override
  void paint(Canvas canvas, Size _) {
    // Будем рисовать каждую «шапку» отдельно (чтобы иметь свой цвет и тень)
    for (final b in bursts) {
      final ampNow = b.maxAmplitude * b.anim.value;
      if (ampNow <= 0.1 || b.halfWidth <= 1) continue;

      final path = Path();
      final double baseY = size.height; // «линия воды» внизу контейнера
      final double startX = (b.centerX - b.halfWidth).clamp(0.0, size.width);
      final double endX = (b.centerX + b.halfWidth).clamp(0.0, size.width);
      if (endX <= startX) continue;

      // локальная «полукосинусная» шапка: 0..π → от 1 до 0
      final step = 4.0; // шаг дискретизации (px) — достаточно гладко
      path.moveTo(startX, baseY);
      for (double x = startX; x <= endX; x += step) {
        final t = ((x - (b.centerX - b.halfWidth)) / (2 * b.halfWidth))
            .clamp(0.0, 1.0);
        // raised-cosine window → параболоидная шапка
        final window = 0.5 * (1.0 + math.cos(math.pi * (t * 2 - 1)));
        final y = baseY - ampNow * window;
        path.lineTo(x, y);
      }
      path.lineTo(endX, baseY);
      path.close();

      // Тень: смещение на (0, 20) + сильное размытие
      final shadowPaint = Paint()
        ..color = b.shadow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120);
      canvas.save();
      canvas.translate(0, 20);
      canvas.drawPath(path, shadowPaint);
      canvas.restore();

      // Заливка волны
      final paint = Paint()..color = b.color;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ReactivePainter oldDelegate) =>
      oldDelegate.bursts != bursts || oldDelegate.size != size;
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

// линейная интерполяция
double _lerp(double a, double b, double t) => a + (b - a) * t;
