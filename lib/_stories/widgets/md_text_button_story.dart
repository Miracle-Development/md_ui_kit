import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:md_ui_kit/widgets/md_text_button.dart';

class MdTextButtonStory extends StatelessWidget {
  const MdTextButtonStory({super.key, required this.knobs});

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    // Текст
    final label = knobs.text(label: 'Text', initial: 'test-peer');

    return Center(
      child: MdTextButton(
        label: label,
        onPressed: () {},
      ),
    );
  }
}
