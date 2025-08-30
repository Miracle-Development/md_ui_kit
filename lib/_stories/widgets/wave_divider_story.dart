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
      initial: WaveDividerType.title,
      options: const [
        Option(
          label: 'title',
          value: WaveDividerType.title,
        ),
        Option(
          label: 'subtitle',
          value: WaveDividerType.subtitle,
        ),
        Option(
          label: 'positive',
          value: WaveDividerType.positive,
        ),
        Option(
          label: 'negative',
          value: WaveDividerType.negative,
        ),
        Option(
          label: 'disabled',
          value: WaveDividerType.disabled,
        ),
        Option(
          label: 'brand',
          value: WaveDividerType.brand,
        ),
        Option(
          label: 'darkBrand',
          value: WaveDividerType.darkBrand,
        ),
      ],
    );

    return Center(
      child: WaveDivider(
        label: label,
        type: type,
      ),
    );
  }
}
