import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:md_ui_kit/widgets/wave_item_badge.dart';

class WaveItemBadgeStory extends StatelessWidget {
  const WaveItemBadgeStory({super.key, required this.knobs});
  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final label = knobs.sliderInt(
      label: 'Notification count',
      initial: 1,
      max: 1000,
      divisions: 1001,
    );

    final style = knobs.options<WaveItemBadgeState>(
      label: 'Style',
      initial: WaveItemBadgeState.unselected,
      options: const [
        Option(label: 'unselected', value: WaveItemBadgeState.unselected),
        Option(label: 'selected', value: WaveItemBadgeState.selected),
      ],
    );

    return WaveItemBadge(
      label: label,
      state: style,
    );
  }
}
