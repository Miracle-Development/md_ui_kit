import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:md_ui_kit/widgets/md_simple_button.dart';
import 'package:md_ui_kit/widgets/md_text.dart';

class MdSimpleButtonStory extends StatelessWidget {
  const MdSimpleButtonStory({super.key, required this.knobs});

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    // текст
    final label = knobs.text(label: 'Text', initial: 'Connect');

    // тип кнопки
    final type = knobs.options<WaveSimpleButtonType>(
      label: 'Type',
      initial: WaveSimpleButtonType.main,
      options: const [
        Option(label: 'main', value: WaveSimpleButtonType.main),
        Option(label: 'alternative', value: WaveSimpleButtonType.alternative),
        Option(label: 'error', value: WaveSimpleButtonType.error),
        Option(label: 'inactive', value: WaveSimpleButtonType.inactive),
      ],
    );

    // вкл/выкл
    final enabled = knobs.boolean(label: 'Enabled', initial: true);

    ///
    // используем MdText как child вместо label
    final useCustomChild = knobs.boolean(label: 'Custom child (MdText)');

    // если включён, даём knobs для MdText
    final mdType = useCustomChild
        ? knobs.options<MdTextType>(
            label: 'MdText.type',
            initial: MdTextType.caption,
            options: const [
              Option(label: 'title (24)', value: MdTextType.title),
              Option(label: 'subtitle (16)', value: MdTextType.subtitle),
              Option(label: 'caption (14)', value: MdTextType.caption),
            ],
          )
        : MdTextType.caption;

    final mdWeight = useCustomChild
        ? knobs.options<MdTextWeight>(
            label: 'MdText.weight',
            initial: MdTextWeight.bold,
            options: const [
              Option(label: 'regular', value: MdTextWeight.regular),
              Option(label: 'bold', value: MdTextWeight.bold),
            ],
          )
        : MdTextWeight.bold;

    final mdColor = useCustomChild
        ? knobs.options<MdTextColor>(
            label: 'MdText.color',
            initial: MdTextColor.defaultColor,
            options: const [
              Option(label: 'default', value: MdTextColor.defaultColor),
              Option(label: 'subtitle', value: MdTextColor.subtitleColor),
              Option(label: 'positive', value: MdTextColor.positiveColor),
              Option(label: 'negative', value: MdTextColor.negativeColor),
              Option(label: 'disabled', value: MdTextColor.disabledColor),
              Option(label: 'brand', value: MdTextColor.brandColor),
            ],
          )
        : MdTextColor.defaultColor;

    final Widget? child = useCustomChild
        ? MdText(
            label,
            type: mdType,
            weight: mdWeight,
            color: mdColor,
          )
        : null;

    ///

    return Center(
      child: MdSimpleButton(
        type: type,
        enabled: enabled,
        onPressed: enabled ? () {} : null,
        // если child не задан, используется label и кнопка сама задаст стиль
        label: useCustomChild ? null : label,
        child: child,
      ),
    );
  }
}
