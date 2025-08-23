import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:md_ui_kit/widgets/md_text.dart';

class MdTextStory extends StatelessWidget {
  const MdTextStory({
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
    final textType = knobs.options<MdTextType>(
      label: 'Type',
      initial: MdTextType.title,
      options: [
        const Option(label: 'Title (24)', value: MdTextType.title),
        const Option(label: 'Subtitle (16)', value: MdTextType.subtitle),
        const Option(label: 'Caption (14)', value: MdTextType.caption),
      ],
    );

    // Weight options
    final textWeight = knobs.options<MdTextWeight>(
      label: 'Weight',
      initial: MdTextWeight.bold,
      options: const [
        Option(
          label: 'regular',
          value: MdTextWeight.regular,
        ),
        Option(label: 'bold', value: MdTextWeight.bold),
      ],
    );

    // Color options
    final textColor = knobs.options<MdTextColor>(
      label: 'Color',
      initial: MdTextColor.brandColor,
      options: const [
        Option(
          label: 'default',
          value: MdTextColor.defaultColor,
        ),
        Option(
          label: 'subtitle',
          value: MdTextColor.subtitleColor,
        ),
        Option(
          label: 'positive',
          value: MdTextColor.positiveColor,
        ),
        Option(
          label: 'negative',
          value: MdTextColor.negativeColor,
        ),
        Option(
          label: 'disabled',
          value: MdTextColor.disabledColor,
        ),
        Option(
          label: 'brand',
          value: MdTextColor.brandColor,
        ),
      ],
    );

    return Center(
      child: MdText(
        text,
        type: textType,
        weight: textWeight,
        color: textColor,
      ),
    );
  }
}
