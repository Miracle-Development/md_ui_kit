import 'package:flutter/material.dart';

import 'package:md_ui_kit/widgets/blurred_circle.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});


  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0xFF0D0D0F),
        ),
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
    );
  }
}


