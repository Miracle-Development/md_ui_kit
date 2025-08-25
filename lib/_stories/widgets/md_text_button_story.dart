import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:md_ui_kit/widgets/md_text_button.dart';
import 'package:md_ui_kit/widgets/md_text.dart';

class MdTextButtonStory extends StatelessWidget {
  const MdTextButtonStory({super.key, required this.knobs});

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    // Текст
    final label = knobs.text(label: 'Text', initial: 'test-peer');

    // Доступность
    final enabled = knobs.boolean(label: 'Enabled', initial: true);

    // Кастомный child через MdText
    final useCustomChild = knobs.boolean(label: 'Custom child (MdText)');

    ///
    Widget? child;
    if (useCustomChild) {
      final mdType = knobs.options<MdTextType>(
        label: 'MdText.type',
        initial: MdTextType.title,
        options: const [
          Option(label: 'title (24)', value: MdTextType.title),
          Option(label: 'subtitle (16)', value: MdTextType.subtitle),
          Option(label: 'caption (14)', value: MdTextType.caption),
        ],
      );

      final mdWeight = knobs.options<MdTextWeight>(
        label: 'MdText.weight',
        initial: MdTextWeight.bold,
        options: const [
          Option(label: 'regular', value: MdTextWeight.regular),
          Option(label: 'bold', value: MdTextWeight.bold),
        ],
      );

      final mdColor = knobs.options<MdTextColor>(
        label: 'MdText.color',
        initial: MdTextColor.brandColor,
        options: const [
          Option(label: 'default', value: MdTextColor.defaultColor),
          Option(label: 'subtitle', value: MdTextColor.subtitleColor),
          Option(label: 'positive', value: MdTextColor.positiveColor),
          Option(label: 'negative', value: MdTextColor.negativeColor),
          Option(label: 'disabled', value: MdTextColor.disabledColor),
          Option(label: 'brand', value: MdTextColor.brandColor),
        ],
      );

      child = MdText(label, type: mdType, weight: mdWeight, color: mdColor);
    }

    ///

    return Center(
      child: MdTextButton(
        label: useCustomChild ? null : label,
        enabled: enabled,
        onPressed: enabled ? () {} : null,
        child: child,
      ),
    );
  }
}
