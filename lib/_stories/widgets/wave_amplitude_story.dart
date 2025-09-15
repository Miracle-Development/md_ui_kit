import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_amplitude.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class WaveAmplitudeStory extends StatelessWidget {
  const WaveAmplitudeStory({super.key, required this.knobs});
  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final level = knobs.slider(
      label: 'level',
      initial: 0,
    );
    return WaveAmplitude(
      level: level,
    );
  }
}
