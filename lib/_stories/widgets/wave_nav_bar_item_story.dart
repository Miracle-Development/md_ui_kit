import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import 'package:md_ui_kit/widgets/wave_nav_bar_item.dart';

class WaveNavBarItemStory extends StatelessWidget {
  const WaveNavBarItemStory({super.key, required this.knobs});
  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final badgeLabel = knobs.sliderInt(
      label: 'Notification count',
      initial: 1,
      max: 1000,
      divisions: 1001,
    );

    final label = knobs.text(label: 'label', initial: 'Connection');
    final tapTogglesSelected = knobs.boolean(label: 'Selected', initial: true);

    final iconAsset = knobs.options<WaveNavBarIcon>(
      label: 'icon',
      initial: WaveNavBarIcon.chat,
      options: const [
        Option(label: 'chat', value: WaveNavBarIcon.chat),
        Option(label: 'mic on', value: WaveNavBarIcon.micOn),
        Option(label: 'mic off', value: WaveNavBarIcon.micOff),
        Option(label: 'phone', value: WaveNavBarIcon.phone),
        Option(label: 'planet', value: WaveNavBarIcon.planet),
        Option(label: 'link', value: WaveNavBarIcon.link),
        Option(label: 'link break', value: WaveNavBarIcon.linkBreak)
      ],
    );

    return WaveNavBarItem(
      label: label,
      icon: iconAsset,
      selected: tapTogglesSelected,
      counter: badgeLabel,
      onTap: () {},
    );
  }
}
