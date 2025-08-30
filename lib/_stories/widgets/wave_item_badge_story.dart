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

    final type = knobs.options<WaveItemBadgeType>(
      label: 'Style',
      initial: WaveItemBadgeType.unselected,
      options: const [
        Option(
          label: 'unselected',
          value: WaveItemBadgeType.unselected,
        ),
        Option(
          label: 'selected',
          value: WaveItemBadgeType.selected,
        ),
      ],
    );

    return WaveItemBadge(
      label: label,
      type: type,
    );
  }
}
