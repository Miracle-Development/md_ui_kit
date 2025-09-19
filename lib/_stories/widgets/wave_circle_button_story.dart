import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_circle_button.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class WaveCircleButtonStory extends StatelessWidget {
  const WaveCircleButtonStory({
    super.key,
    required this.knobs,
  });

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final label = knobs.text(
      label: 'Subtitle',
      initial: 'Settings',
    );

    final type = knobs.options<WaveCircleButtonType>(
      label: 'Type',
      initial: WaveCircleButtonType.setting,
      options: const [
        Option(
          label: 'Setting',
          value: WaveCircleButtonType.setting,
        ),
        Option(
          label: 'Leave call',
          value: WaveCircleButtonType.leaveCall,
        ),
        Option(
          label: 'Start call',
          value: WaveCircleButtonType.startCall,
        ),
      ],
    );

    final selected = knobs.boolean(label: "selected");

    return WaveCircleButton(
      subtitle: label,
      type: type,
      selected: selected,
      onTap: () => print("WaveCircleButton Test"),
    );
  }
}
