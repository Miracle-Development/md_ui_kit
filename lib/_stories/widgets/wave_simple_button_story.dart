import 'package:flutter/material.dart';
import 'package:md_ui_kit/md_ui_kit.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:md_ui_kit/widgets/wave_simple_button.dart';

class WaveSimpleButtonStory extends StatelessWidget {
  const WaveSimpleButtonStory({
    super.key,
    required this.knobs,
  });

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    // текст
    final label = knobs.text(
      label: 'Text',
      initial: 'Connect',
    );

    // тип кнопки
    final type = knobs.options<WaveButtonType>(
      label: 'Type',
      initial: WaveButtonType.main,
      options: const [
        Option(
          label: 'main',
          value: WaveButtonType.main,
        ),
        Option(
          label: 'alternative',
          value: WaveButtonType.alternative,
        ),
        Option(
          label: 'error',
          value: WaveButtonType.error,
        ),
        Option(
          label: 'inactive',
          value: WaveButtonType.inactive,
        ),
      ],
    );

    // вкл/выкл
    final enabled = knobs.boolean(
      label: 'Enabled',
      initial: true,
    );

    return WaveSimpleButton(
      type: type,
      onPressed: !enabled ? () {} : () => print("WaveSimpleButton Test"),
      label: label,
    );
  }
}
