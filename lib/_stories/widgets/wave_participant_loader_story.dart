import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_participant_loader.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class WaveParticipantLoaderStory extends StatelessWidget {
  const WaveParticipantLoaderStory({
    super.key,
    required this.knobs,
  });

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final direction = knobs.options<WaveParticipantLoaderDirection>(
        label: "Direction",
        initial: WaveParticipantLoaderDirection.leftToRight,
        options: const [
          Option(
              label: "left to right",
              value: WaveParticipantLoaderDirection.leftToRight),
          Option(
              label: "right to left",
              value: WaveParticipantLoaderDirection.rightToLeft),
        ]);

    return WaveParticipantLoader(
      direction: direction,
    );
  }
}
