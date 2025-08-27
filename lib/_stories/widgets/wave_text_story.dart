import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';

class WaveTextStory extends StatelessWidget {
  const WaveTextStory({
    super.key,
    required this.knobs,
  });

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final text = knobs.text(
      label: 'Text',
      initial: 'This is text example',
    );

    // Type options
    final textType = knobs.options<WaveTextType>(
      label: 'Type',
      initial: WaveTextType.title,
      options: [
        const Option(label: 'Title (24)', value: WaveTextType.title),
        const Option(label: 'Subtitle (16)', value: WaveTextType.subtitle),
        const Option(label: 'Caption (14)', value: WaveTextType.caption),
        const Option(label: 'Badge (8)', value: WaveTextType.badge)
      ],
    );

    // Weight options
    final textWeight = knobs.options<WaveTextWeight>(
      label: 'Weight',
      initial: WaveTextWeight.bold,
      options: const [
        Option(
          label: 'regular',
          value: WaveTextWeight.regular,
        ),
        Option(label: 'bold', value: WaveTextWeight.bold),
      ],
    );

    // Color options
    final textColor = knobs.options<WaveTextColor>(
      label: 'Color',
      initial: WaveTextColor.brandColor,
      options: const [
        Option(
          label: 'default',
          value: WaveTextColor.defaultColor,
        ),
        Option(
          label: 'subtitle',
          value: WaveTextColor.subtitleColor,
        ),
        Option(
          label: 'positive',
          value: WaveTextColor.positiveColor,
        ),
        Option(
          label: 'negative',
          value: WaveTextColor.negativeColor,
        ),
        Option(
          label: 'disabled',
          value: WaveTextColor.disabledColor,
        ),
        Option(
          label: 'brand',
          value: WaveTextColor.brandColor,
        ),
        Option(
          label: 'darkBrand',
          value: WaveTextColor.darkBrandColor,
        ),
      ],
    );

    return WaveText(
      text,
      type: textType,
      weight: textWeight,
      waveColor: textColor,
    );
  }
}
