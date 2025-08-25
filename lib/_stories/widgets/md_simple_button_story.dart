import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:md_ui_kit/widgets/md_simple_button.dart';

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

    return Center(
      child: MdSimpleButton(
        type: type,
        enabled: enabled,
        onPressed: enabled ? () {} : null,
        label: label,
      ),
    );
  }
}
