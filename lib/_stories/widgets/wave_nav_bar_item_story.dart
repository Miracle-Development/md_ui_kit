import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_item_badge.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import 'package:md_ui_kit/widgets/wave_nav_bar_item.dart';
import 'package:md_ui_kit/_core/precached_icons.dart';

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

    final iconAsset = knobs.options<String>(
      label: 'icon',
      initial: PrecachedIcons.navBarLinkIcon,
      options: const [
        Option(label: 'chat', value: PrecachedIcons.navBarChatIcon),
        Option(label: 'link', value: PrecachedIcons.navBarLinkIcon),
        Option(label: 'link break', value: PrecachedIcons.navBarLinkBreakIcon),
        Option(label: 'mic on', value: PrecachedIcons.navBarMicOnIcon),
        Option(label: 'mic off', value: PrecachedIcons.navBarMicOffIcon),
        Option(label: 'phone', value: PrecachedIcons.navBarPhoneIcon),
        Option(label: 'planet', value: PrecachedIcons.navBarPlanetIcon),
      ],
    );

    return WaveNavBarItem(
      iconAsset: iconAsset,
      label: label,
      waveItemBadge: WaveItemBadge(label: badgeLabel),
      selected: tapTogglesSelected,
      onTap: () {},
    );
  }
}
