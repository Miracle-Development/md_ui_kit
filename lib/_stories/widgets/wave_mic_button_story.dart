import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_mic_button.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class WaveMicButtonStory extends StatelessWidget {
  const WaveMicButtonStory({super.key, required this.knobs});
  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    return const WaveMicButton();
  }
}
