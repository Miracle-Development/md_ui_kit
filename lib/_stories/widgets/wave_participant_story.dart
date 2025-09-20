import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_participant.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class WaveParticipantStory extends StatelessWidget {
  const WaveParticipantStory({
    super.key,
    required this.knobs,
  });
  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final label = knobs.text(
      label: 'label',
      initial: 'Peer',
    );

    final inCallFlag = knobs.boolean(label: 'inCall');

    final muted = knobs.boolean(label: 'muted');

    return WaveParticipant(
      label: label,
      inCall: inCallFlag,
      muted: muted,
    );
  }
}
