import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/blurred_circle.dart';
import 'package:md_ui_kit/widgets/wave_logo.dart';

class GradientScaffoldWrapper extends StatelessWidget {
  const GradientScaffoldWrapper({
    super.key,
    required this.child,
    required this.showLogo,
  });

  final Widget child;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xFF0D0D0F),
            ),
            child: Stack(
              children: [
                if (showLogo)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: WaveLogo(),
                      ),
                    ],
                  ),

                /// Основной скролл-контент
                Padding(
                  padding: const EdgeInsets.only(top: 68.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                            minWidth: constraints.maxWidth,
                          ),
                          child: child,
                        ),
                      );
                    },
                  ),
                ),

                /// Декоративные круги (поверх, но некликабельные)
                IgnorePointer(
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
      ),
    );
  }
}
