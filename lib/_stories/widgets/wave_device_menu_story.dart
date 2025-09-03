import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_device_menu.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class WaveDeviceMenuStory extends StatelessWidget {
  const WaveDeviceMenuStory({
    super.key,
    required this.knobs,
  });

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    return WaveDeviceMenu(
      items: const ['Device 1', 'Device 2', 'Device 3'],
      onChanged: () {},
    );
  }
}
