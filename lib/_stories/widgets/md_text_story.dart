import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:md_ui_kit/widgets/md_text.dart';

class MdTextStory extends StatelessWidget {
  const MdTextStory({super.key, required this.knobs});
  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final text = knobs.text(
      label: 'text',
      initial: 'This is text example',
    );

    // Селект типа
    final widgetType = knobs.options<MdTextPreset>(
      label: 'type',
      initial: MdText.caption,
      options: [
        const Option(label: 'title (24)', value: MdText.title),
        const Option(label: 'subtitle (16)', value: MdText.subtitle),
        const Option(label: 'caption (14)', value: MdText.caption),
      ],
    );

    // Селект вейта (динамический)
    final widgetWeightPreset = knobs.options<MdTextPreset>(
      label: 'weight (${widgetType.type.name})',
      initial: widgetType.regular,
      options: [
        Option(label: 'regular', value: widgetType.regular),
        Option(label: 'bold', value: widgetType.bold),
      ],
    );

    // Селект цвета
    final widgetColor = knobs.options<MdTextColor>(
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

    final widget = widgetWeightPreset.copyWith(color: widgetColor)(text);
    return Center(child: widget);
  }
}
