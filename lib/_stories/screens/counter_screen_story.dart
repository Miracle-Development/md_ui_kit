import 'package:flutter/material.dart';
import 'package:md_ui_kit/screens/counter_screen.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class CounterScreenStory extends StatelessWidget {
  const CounterScreenStory({
    super.key,
    required this.knobs,
  });

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final title = context.knobs.text(
      label: 'Title',
      initial: 'Counter',
    );
    final enabled = context.knobs.boolean(
      label: 'Enabled',
      initial: true,
    );

    return CounterScreen(
      title: title,
      enabled: enabled,
    );
  }
}
