import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class PrecachedIcons {
  const PrecachedIcons();

  static const copyDefaultIcon = 'assets/icons/copy/copy_default.svg';
  static const copyPressedIcon = 'assets/icons/copy/copy_pressed.svg';
  static const navBarChatIcon = 'assets/icons/navbar/chat.svg';
  static const navBarLinkIcon = 'assets/icons/navbar/link.svg';
  static const navBarLinkBreakIcon = 'assets/icons/navbar/link_break.svg';
  static const navBarMicOnIcon = 'assets/icons/navbar/mic_on.svg';
  static const navBarMicOffIcon = 'assets/icons/navbar/mic_off.svg';
  static const navBarPhoneIcon = 'assets/icons/navbar/phone.svg';
  static const navBarPlanetIcon = 'assets/icons/navbar/planet.svg';

  List<SvgAssetLoader> get iconsToPrecache => const [
        SvgAssetLoader(copyDefaultIcon),
        SvgAssetLoader(copyPressedIcon),
        SvgAssetLoader(navBarChatIcon),
        SvgAssetLoader(navBarLinkIcon),
        SvgAssetLoader(navBarLinkBreakIcon),
        SvgAssetLoader(navBarMicOnIcon),
        SvgAssetLoader(navBarMicOffIcon),
        SvgAssetLoader(navBarPhoneIcon),
        SvgAssetLoader(navBarPlanetIcon),
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
