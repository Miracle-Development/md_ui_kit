import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class PrecachedIcons {
  const PrecachedIcons();

  static const copyDefaultIcon =
      'assets/icons/copy/copy_default.svg';
  static const copyPressedIcon =
      'assets/icons/copy/copy_pressed.svg';

  List<SvgAssetLoader> get iconsToPrecache => const [
        SvgAssetLoader(copyDefaultIcon),
        SvgAssetLoader(copyPressedIcon),
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
