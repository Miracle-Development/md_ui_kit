import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

/// level — вход (0..1), от него волны «надуваются»/«сдуваются»
class WaveAmplitude extends StatelessWidget {
  const WaveAmplitude({
    super.key,
    required this.level, // 0..1
    this.height = 92, // ~как в макете: 91.5
    this.width,
  });

  final double level;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    // Подбираем амплитуды и «линию воды» под уровень:
    final ampNear = lerpDouble(2, 14, level)!.toDouble(); // ближняя волна
    final ampMiddle = lerpDouble(1, 10, level)!.toDouble();
    final ampFar = lerpDouble(0, 6, level)!.toDouble();

    // Сдвигаем «базовую высоту» слоёв (0..1 от высоты виджета)
    final baseNear = lerpDouble(0.62, 0.45, level)!;
    final baseMiddle = lerpDouble(0.66, 0.55, level)!;
    final baseFar = lerpDouble(0.70, 0.62, level)!;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Мягкая падающая тень (как в фигме: blur 120, offset y=20)
          const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(48, 51, 212, 0.25),
                  blurRadius: 120,
                  offset: Offset(0, 20),
                ),
              ]),
            ),
          ),

          // Дальний слой: самый прозрачный, медленный
          WaveWidget(
            config: CustomConfig(
              colors: const [Color.fromRGBO(48, 51, 212, 0.18)],
              durations: const [9000], // самая «лёгкая» волна
              heightPercentages: [baseFar], // базовая линия
            ),
            waveAmplitude: ampFar, // амплитуда в px
            backgroundColor: Colors.transparent,
            size: Size.infinite,
          ),

          // Средний слой
          WaveWidget(
            config: CustomConfig(
              colors: const [Color.fromRGBO(67, 70, 243, 0.30)],
              durations: const [6500],
              heightPercentages: [baseMiddle],
            ),
            waveAmplitude: ampMiddle,
            backgroundColor: Colors.transparent,
            size: Size.infinite,
          ),

          // Передний слой: ярче/контрастнее, быстрее
          WaveWidget(
            config: CustomConfig(
              colors: const [Color.fromRGBO(140, 141, 227, 0.40)],
              durations: const [4800],
              heightPercentages: [baseNear],
            ),
            waveAmplitude: ampNear,
            backgroundColor: Colors.transparent,
            size: Size.infinite,
          ),
        ],
      ),
    );
  }
}
