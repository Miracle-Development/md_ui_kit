import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/blurred_circle.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class BlurredCircleStory extends StatelessWidget {
  const BlurredCircleStory({super.key, required this.knobs});

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final isCustomBlur =
        context.knobs.boolean(label: 'Custom Blur', initial: true);

    final alignment = context.knobs.options(
      label: 'Alignment',
      initial: Alignment.center,
      options: const [
        Option(label: 'topLeft', value: Alignment.topLeft),
        Option(label: 'topCenter', value: Alignment.topCenter),
        Option(label: 'topRight', value: Alignment.topRight),
        Option(label: 'centerLeft', value: Alignment.centerLeft),
        Option(label: 'center', value: Alignment.center),
        Option(label: 'centerRight', value: Alignment.centerRight),
        Option(label: 'bottomLeft', value: Alignment.bottomLeft),
        Option(label: 'bottomCenter', value: Alignment.bottomCenter),
        Option(label: 'bottomRight', value: Alignment.bottomRight),
      ],
    );

    final offsetX = context.knobs
        .slider(label: 'Offset X', initial: 0, min: -200, max: 200);
    final offsetY = context.knobs
        .slider(label: 'Offset Y', initial: 0, min: -200, max: 200);
    final radius =
        context.knobs.slider(label: 'Radius', initial: 128, min: 10, max: 300);
    final blur =
        context.knobs.slider(label: 'Blur', initial: 100, min: 5, max: 400);

    return isCustomBlur
        ? BlurredCircle(
            alignment: alignment,
            offset: Offset(offsetX, offsetY),
            radius: radius,
            blur: blur,
            color: const Color.fromRGBO(67, 70, 243, 0.6),
          )
        : ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              width: radius,
              height: radius,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(67, 70, 243, 0.6),
                  shape: BoxShape.circle),
              alignment: alignment,
            ),
          );
  }
}
