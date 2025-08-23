import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:md_ui_kit/widgets/md_text.dart';

// Стори для нашего макета текста

class MdTextStory extends StatelessWidget {
  const MdTextStory({super.key, required this.knobs});

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    // Всякие разные опция для кастомизации
    final text = knobs.text(
      label: 'title',
      initial: 'This is text example',
    );

    final type = knobs.options<MdTextType>(
      label: 'type',
      initial: MdTextType.title,
      options: const [
        Option(label: 'title (24)', value: MdTextType.title),
        Option(label: 'subtitle (16)', value: MdTextType.subtitle),
        Option(label: 'caption (14)', value: MdTextType.caption),
      ],
    );

    final weight = knobs.options<MdTextWeight>(
      label: 'weight',
      initial: MdTextWeight.regular,
      options: const [
        Option(label: 'regular', value: MdTextWeight.regular),
        Option(label: 'bold', value: MdTextWeight.bold),
      ],
    );

    final color = knobs.options<MdTextColor>(
      label: 'color',
      initial: MdTextColor.defaultColor,
      options: const [
        Option(label: 'textDefaultColor', value: MdTextColor.defaultColor),
        Option(label: 'textSubtitleColor', value: MdTextColor.subtitleColor),
        Option(label: 'textPositiveColor', value: MdTextColor.positiveColor),
        Option(label: 'textNegativeColor', value: MdTextColor.negativeColor),
        Option(label: 'textDisabledColor', value: MdTextColor.disabledColor),
        Option(label: 'textBrandColor', value: MdTextColor.brandColor),
      ],
    );

    // Отображение самого виджета
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MdText(
            text,
            type: type,
            weight: weight,
            color: color,
          ),
        ],
      ),
    );
  }
}
