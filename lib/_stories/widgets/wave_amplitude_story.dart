import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_amplitude.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class WaveAmplitudeStory extends StatelessWidget {
  const WaveAmplitudeStory({super.key, required this.knobs});
  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final isSpeaking = knobs.boolean(label: "Speak", initial: true);
    return WaveAmplitude(
      onVoice: isSpeaking,
    );
  }
}
