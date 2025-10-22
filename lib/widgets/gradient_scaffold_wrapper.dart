import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:md_ui_kit/_core/precached_icons.dart';
import 'package:md_ui_kit/widgets/blurred_circle.dart';
import 'package:md_ui_kit/widgets/wave_logo.dart';

class GradientScaffoldWrapper extends StatelessWidget {
  const GradientScaffoldWrapper({
    super.key,
    required this.child,
    required this.showLogo,
    this.iosTopPadding = 80,
    this.onTapBack,
    this.showArrow = true,
  });

  final Widget child;
  final bool showLogo;
  final double? iosTopPadding;
  final VoidCallback? onTapBack;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xFF0D0D0F),
          ),
          child: Stack(
            children: [
              if (showLogo)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: iosTopPadding != null ? iosTopPadding! : 20,
                        bottom: 20,
                        left: 20,
                      ),
                      child: InkWell(
                        onTap: onTapBack?.call,
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            PrecachedIcons.backArrow,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: iosTopPadding != null ? iosTopPadding! : 20,
                        bottom: 20,
                      ),
                      child: const WaveLogo(),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),

              /// Основной скролл-контент
              Padding(
                padding: EdgeInsets.only(
                    top: iosTopPadding != null ? iosTopPadding! + 48 : 68),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                        minWidth: constraints.maxWidth,
                      ),
                      child: child,
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
    );
  }
}
