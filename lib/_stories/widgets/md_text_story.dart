import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:md_ui_kit/widgets/md_text.dart';

class MdTextStory extends StatelessWidget {
  const MdTextStory({super.key, required this.knobs});
  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final textData = knobs.text(
      label: 'text',
      initial: 'This is text example',
    );

    // Селект типа
    final presetBase = knobs.options<MdTextPreset>(
      label: 'type',
      initial: MdText.caption,
      options: [
        const Option(label: 'title (24)', value: MdText.title),
        const Option(label: 'subtitle (16)', value: MdText.subtitle),
        const Option(label: 'caption (14)', value: MdText.caption),
      ],
    );

    // Селект вейта
    final weight = knobs.options<MdTextWeight>(
      label: 'weight',
      initial: MdTextWeight.regular,
      options: const [
        Option(label: 'regular', value: MdTextWeight.regular),
        Option(label: 'bold', value: MdTextWeight.bold),
      ],
    );

    // Селект цвета
    final color = knobs.options<MdTextColor>(
      label: 'color',
      initial: MdTextColor.defaultColor,
      options: const [
        Option(label: 'default', value: MdTextColor.defaultColor),
        Option(label: 'subtitle', value: MdTextColor.subtitleColor),
        Option(label: 'positive', value: MdTextColor.positiveColor),
        Option(label: 'negative', value: MdTextColor.negativeColor),
        Option(label: 'disabled', value: MdTextColor.disabledColor),
        Option(label: 'brand', value: MdTextColor.brandColor),
      ],
    );

    final widget =
        presetBase.copyWith(weight: weight).copyWith(color: color)(textData);
    return Center(
      child: widget,
    );
  }
}
