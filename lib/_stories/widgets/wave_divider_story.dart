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

    final color = knobs.options<WaveDividerColor>(
      label: 'Color',
      initial: WaveDividerColor.titleColor,
      options: const [
        Option(
          label: 'titleColor',
          value: WaveDividerColor.titleColor,
        ),
        Option(
          label: 'subtitleColor',
          value: WaveDividerColor.subtitleColor,
        ),
        Option(
          label: 'positiveColor',
          value: WaveDividerColor.positiveColor,
        ),
        Option(
          label: 'negativeColor',
          value: WaveDividerColor.negativeColor,
        ),
        Option(
          label: 'disabledColor',
          value: WaveDividerColor.disabledColor,
        ),
        Option(
          label: 'brandColor',
          value: WaveDividerColor.brandColor,
        ),
        Option(
          label: 'darkBrandColor',
          value: WaveDividerColor.darkBrandColor,
        ),
      ],
    );

    return WaveDivider(
      label: label,
      color: color,
    );
  }
}
