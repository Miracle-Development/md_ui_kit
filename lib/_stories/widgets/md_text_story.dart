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

    // Флажок насыщенности
    final isBold = knobs.boolean(label: 'Bold');

    final preset =
        (isBold ? presetBase.bold : presetBase).copyWith(color: color);

    return Center(
      child: preset(textData),
    );
  }
}
