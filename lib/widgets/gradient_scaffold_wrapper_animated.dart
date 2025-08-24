import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/gradient_scaffold_wrapper.dart';

class GradientScaffoldWrapperAnimated extends StatefulWidget {
  const GradientScaffoldWrapperAnimated({super.key, required this.child});
  final Widget child;

  @override
  State<GradientScaffoldWrapperAnimated> createState() =>
      _GradientScaffoldWrapperAnimatedState();
}

class _GradientScaffoldWrapperAnimatedState
    extends State<GradientScaffoldWrapperAnimated>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _showCircles = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    // запуск проявления через 1.5 сек
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _showCircles = true;
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
    return Scaffold(
      body: SizedBox.expand(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: const BoxDecoration(
            color: Color(0xFF0D0D0F),
          ),
          child: Stack(
            children: [
              SafeArea(child: widget.child),

              // плавное проявление кругов
              AnimatedOpacity(
                opacity: _showCircles ? 1.0 : 0.0,
                duration: const Duration(seconds: 1), // скорость проявления
                curve: Curves.easeInOut,
                child: Stack(
                  children: [
                    BlurredCircle(
                      alignment: Alignment.topCenter,
                      offset: const Offset(0, -100),
                      radius: 128,
                      blur: 100,
                      color: const Color(0xFF1B2CE9).withAlpha(13),
                    ),
                    BlurredCircle(
                      alignment: Alignment.centerRight,
                      offset: const Offset(125, 0),
                      radius: 183,
                      blur: 400,
                      color: const Color(0xFF7C41F3).withAlpha(20),
                    ),
                    BlurredCircle(
                      alignment: Alignment.bottomLeft,
                      offset: const Offset(65, -68),
                      radius: 136,
                      blur: 400,
                      color: const Color(0xFF4145F3).withAlpha(13),
                    ),
                    BlurredCircle(
                      alignment: Alignment.bottomLeft,
                      offset: const Offset(106, 0),
                      radius: 136,
                      blur: 400,
                      color: const Color(0xFF1B2CE9).withAlpha(13),
                    ),
                    BlurredCircle(
                      alignment: Alignment.bottomLeft,
                      offset: const Offset(31, -19),
                      radius: 136,
                      blur: 400,
                      color: const Color(0xFF1B2CE9).withAlpha(13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
