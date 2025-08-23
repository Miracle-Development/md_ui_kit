import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/md_initial_wave.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class MdTextStory extends StatelessWidget {
  const MdTextStory({super.key, required this.knobs});

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    return const MdInitialWave();
  }
}
