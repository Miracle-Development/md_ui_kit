import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import 'package:md_ui_kit/widgets/wave_nav_bar_item.dart';

class WaveNavBarItemStory extends StatelessWidget {
  const WaveNavBarItemStory({
    super.key,
    required this.knobs,
  });
  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final badgeLabel = knobs.sliderInt(
      label: 'Notification count',
      initial: 1,
      max: 1000,
      divisions: 1001,
    );

    final label = knobs.text(
      label: 'label',
      initial: 'Connection',
    );
    final tapTogglesSelected = knobs.boolean(label: 'Selected');

    final iconAsset = knobs.options<NavBarIconType>(
      label: 'icon',
      initial: NavBarIconType.chat,
      options: const [
        Option(
          label: 'chat',
          value: NavBarIconType.chat,
        ),
        Option(
          label: 'mic on',
          value: NavBarIconType.micOn,
        ),
        Option(
          label: 'mic off',
          value: NavBarIconType.micOff,
        ),
        Option(
          label: 'phone',
          value: NavBarIconType.phone,
        ),
        Option(
          label: 'planet',
          value: NavBarIconType.planet,
        ),
        Option(
          label: 'link',
          value: NavBarIconType.link,
        ),
        Option(
          label: 'link break',
          value: NavBarIconType.linkBreak,
        ),
      ],
    );

    return WaveNavBarItem(
      label: label,
      icon: iconAsset,
      selected: tapTogglesSelected,
      counter: badgeLabel,
      onTap: () {
        print('WaveNavBarItem Test');
      },
    );
  }
}
