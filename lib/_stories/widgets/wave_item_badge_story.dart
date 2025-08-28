import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:md_ui_kit/widgets/wave_item_badge.dart';

class WaveItemBadgeStory extends StatelessWidget {
  const WaveItemBadgeStory({super.key, required this.knobs});
  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final label = knobs.text(label: 'Text', initial: '123456789');

    final style = knobs.options<WaveItemBadgeStyle>(
      label: 'Style',
      initial: WaveItemBadgeStyle.unselected,
      options: const [
        Option(label: 'unselected', value: WaveItemBadgeStyle.unselected),
        Option(label: 'selected', value: WaveItemBadgeStyle.selected),
      ],
    );

    return WaveItemBadge(
      label: label,
      style: style,
    );
  }
}
