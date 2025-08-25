import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/gradient_scaffold_wrapper_animated.dart';
import 'package:md_ui_kit/widgets/md_initial_wave.dart';
import 'package:md_ui_kit/widgets/md_text.dart';
import 'package:md_ui_kit/widgets/wave_logo.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({
    super.key,
    this.screenWidth,
    this.screenHeight,
    this.waitingDuration = 2000,
    this.wavePositionedBottom = 235,
  });
  final double wavePositionedBottom;
  final double? screenWidth;
  final double? screenHeight;
  final int? waitingDuration;

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
      duration: const Duration(seconds: 2),
    )..forward();

    // запуск проявления через 1.5 сек
    Future.delayed(Duration(milliseconds: widget.waitingDuration!), () {
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
      child: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: _showTitle ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                child: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: WaveLogo(),
                    ),
                  ],
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
                  child: const MdText(
                    'peer-to-peer chat&calls',
                    type: MdTextType.caption,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
