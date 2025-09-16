import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class WaveAmplitude extends StatefulWidget {
  const WaveAmplitude({
    super.key,
    this.level = 3,
    this.height = 90,
    this.onVoice = true,
  });

  final double level;
  final double height;
  final bool onVoice;

  @override
  State<WaveAmplitude> createState() => _WaveAmplitudeState();
}

class _WaveAmplitudeState extends State<WaveAmplitude> {
  @override
  Widget build(BuildContext context) {
    final ampNearBase = lerpDouble(2, 14, widget.level)!.toDouble();
    final ampMiddleBase = lerpDouble(1, 10, widget.level)!.toDouble();
    final ampFarBase = lerpDouble(0, 6, widget.level)!.toDouble();

    final baseNear = lerpDouble(0.62, 0.45, widget.level)!;
    final baseMiddle = lerpDouble(0.66, 0.55, widget.level)!;
    final baseFar = lerpDouble(0.70, 0.62, widget.level)!;

    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
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
          WaveWidget(
            config: CustomConfig(
              colors: [
                widget.onVoice
                    ? const Color.fromRGBO(48, 51, 212, 0.40)
                    : Colors.transparent,
              ],
              durations: const [9000],
              heightPercentages: [baseFar],
            ),
            waveAmplitude: ampNearBase,
            backgroundColor: Colors.transparent,
            size: Size.infinite,
          ),
          WaveWidget(
            config: CustomConfig(
              colors: [
                widget.onVoice
                    ? const Color.fromRGBO(67, 70, 243, 0.40)
                    : Colors.transparent,
              ],
              durations: const [6500],
              heightPercentages: [baseMiddle],
            ),
            waveAmplitude: ampMiddleBase,
            backgroundColor: Colors.transparent,
            size: Size.infinite,
          ),
          WaveWidget(
            config: CustomConfig(
              colors: [
                widget.onVoice
                    ? const Color.fromRGBO(140, 141, 227, 0.30)
                    : Colors.transparent,
              ],
              durations: const [4800],
              heightPercentages: [baseNear],
            ),
            waveAmplitude: ampFarBase,
            backgroundColor: Colors.transparent,
            size: Size.infinite,
          ),
        ],
      ),
    );
  }
}
