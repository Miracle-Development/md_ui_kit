import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/gradient_scaffold_wrapper_animated.dart';
import 'package:md_ui_kit/widgets/md_initial_wave.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';
import 'package:md_ui_kit/widgets/wave_logo.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({
    super.key,
    this.screenWidth,
    this.screenHeight,
    this.wavePositionedBottom = 235,
  });
  final double wavePositionedBottom;
  final double? screenWidth;
  final double? screenHeight;

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    Future.delayed(const Duration(milliseconds: 4000), () {
      if (mounted) {
        setState(() {
          _showTitle = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GradientScaffoldWrapperAnimated(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 20,
            child: AnimatedOpacity(
              opacity: _showTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              child: const WaveLogo(),
            ),
          ),
          Positioned(
            bottom: widget.wavePositionedBottom *
                ((widget.screenHeight ?? height) /
                    (widget.screenWidth ?? width)),
            left: 0,
            right: 0,
            child: const MdInitialWave(),
          ),
          Positioned(
            bottom: 60,
            child: AnimatedOpacity(
              opacity: _showTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              child: const WaveText(
                'peer-to-peer chat&calls',
                type: WaveTextType.caption,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
