import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class PrecachedIcons {
  const PrecachedIcons();

  static const copyDefaultIcon = 'assets/icons/copy/copy_default.svg';
  static const copyPressedIcon = 'assets/icons/copy/copy_pressed.svg';
  static const navBarChatIcon = 'assets/icons/nav_bar/chat.svg';
  static const navBarLinkIcon = 'assets/icons/nav_bar/link.svg';
  static const navBarLinkBreakIcon = 'assets/icons/nav_bar/link_break.svg';
  static const navBarMicOnIcon = 'assets/icons/nav_bar/mic_on.svg';
  static const navBarMicOffLineIcon = 'assets/icons/nav_bar/line_mic_off.svg';
  static const navBarPhoneIcon = 'assets/icons/nav_bar/phone.svg';
  static const navBarPlanetIcon = 'assets/icons/nav_bar/planet.svg';
  static const micButton = 'assets/icons/mic/microphone_button.svg';

  List<SvgAssetLoader> get iconsToPrecache => const [
        SvgAssetLoader(copyDefaultIcon),
        SvgAssetLoader(copyPressedIcon),
        SvgAssetLoader(navBarChatIcon),
        SvgAssetLoader(navBarLinkIcon),
        SvgAssetLoader(navBarLinkBreakIcon),
        SvgAssetLoader(navBarMicOnIcon),
        SvgAssetLoader(navBarMicOffLineIcon),
        SvgAssetLoader(navBarPhoneIcon),
        SvgAssetLoader(navBarPlanetIcon),
        SvgAssetLoader(micButton),
      ];

  void precache(BuildContext context) {
    for (final icon in iconsToPrecache) {
      svg.cache.putIfAbsent(
        icon.cacheKey(context),
        () => icon.loadBytes(context),
      );
    }
  }
}
