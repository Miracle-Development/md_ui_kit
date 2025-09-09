import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_chat_input.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class WaveChatInputStory extends StatelessWidget {
  const WaveChatInputStory({super.key, required this.knobs});
  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final hintText = knobs.text(label: "HintText", initial: "some text");
    final enabled = knobs.boolean(
      label: 'Enabled',
      initial: true,
    );
    return WaveChatInput(
      hintText: hintText,
      enabled: enabled,
      onSend: () => print(123),
    );
  }
}
