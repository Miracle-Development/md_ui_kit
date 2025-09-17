import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_hint_text.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class WaveHintTextStory extends StatelessWidget {
  const WaveHintTextStory({
    super.key,
    required this.knobs,
  });

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final part1 = knobs.text(
      label: 'Text (bold part)',
      initial: 'Bold part: ',
    );

    final part2 = knobs.text(
      label: 'Text (regular part)',
      initial: 'Regular part',
    );

    return Center(
      child: WaveHintText(
        boldPart: part1,
        normalPart: part2,
      ),
    );
  }
}
