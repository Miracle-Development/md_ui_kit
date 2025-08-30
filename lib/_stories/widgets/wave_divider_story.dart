import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_divider.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class WaveDividerStory extends StatelessWidget {
  const WaveDividerStory({
    super.key,
    required this.knobs,
  });

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    // Текст
    final label = knobs.text(
      label: 'Text',
      initial: 'Or',
    );

    final type = knobs.options<WaveDividerType>(
      label: 'Type',
      initial: WaveDividerType.done,
      options: const [
        Option(
          label: 'positive',
          value: WaveDividerType.positive,
        ),
        Option(
          label: 'negative',
          value: WaveDividerType.negative,
        ),
        Option(
          label: 'process',
          value: WaveDividerType.process,
        ),
        Option(
          label: 'done',
          value: WaveDividerType.done,
        ),
      ],
    );

    return WaveDivider(
      label: label,
      type: type,
    );
  }
}
