import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:md_ui_kit/widgets/wave_text_button.dart';

class MdTextButtonStory extends StatelessWidget {
  const MdTextButtonStory({
    super.key,
    required this.knobs,
  });

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    // Текст
    final label = knobs.text(
      label: 'Text',
      initial: 'test-peer',
    );

    final enabled = knobs.boolean(label: "Enabled");

    return Center(
      child: WaveTextButton(
        label: label,
        onPressed: enabled ? () => print("WaveTextButton Test") : null,
      ),
    );
  }
}
