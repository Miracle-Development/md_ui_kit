import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/gradient_background.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class GradientBackgroundStory extends StatelessWidget {
  const GradientBackgroundStory({super.key, required this.knobs});

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final showLogo = context.knobs.boolean(
      label: 'Show logo',
      initial: true,
    );

    return GradientBackground(showLogo: showLogo);
  }
}
