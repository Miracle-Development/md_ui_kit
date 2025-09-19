import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/_core/precached_icons.dart';
import 'package:md_ui_kit/md_ui_kit.dart';

class WaveCircleButton extends StatefulWidget {
  const WaveCircleButton({
    super.key,
    required this.type,
    required this.subtitle,
    this.selected = false,
    this.onTap,
  });

  final WaveCircleButtonType type;
  final bool selected;
  final VoidCallback? onTap;
  final String subtitle;

  @override
  State<WaveCircleButton> createState() => _WaveCircleButtonState();
}

class _WaveCircleButtonState extends State<WaveCircleButton> {
  bool isPressed = false;
  bool isHover = false;
  String icon = "";
  static const duration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final WaveCircleButtonState uiState = isPressed
        ? WaveCircleButtonState.pressed
        : (isHover
            ? WaveCircleButtonState.hover
            : WaveCircleButtonState.normal);

    final colors = _resolveCircleButtonColors(
      widget.type,
      uiState,
      widget.selected,
    );

    final String icon = switch (widget.type) {
      WaveCircleButtonType.setting => PrecachedIcons.settingsButton,
      WaveCircleButtonType.leaveCall => PrecachedIcons.leaveCallButton,
      WaveCircleButtonType.startCall => PrecachedIcons.startCallButton,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => isHover = true),
          onExit: (_) => setState(() => isHover = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => isPressed = true),
            onTapUp: (_) => setState(() {
              isPressed = false;
            }),
            onTapCancel: () => setState(() => isPressed = false),
            onTap: () {
              widget.onTap?.call();
            },
            child: AnimatedContainer(
              duration: duration,
              curve: Curves.ease,
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.background,
              ),
              child: Center(
                child: TweenAnimationBuilder<Color?>(
                  tween: ColorTween(end: colors.icon),
                  duration: duration,
                  curve: Curves.ease,
                  child: SvgPicture.asset(icon, width: 36, height: 36),
                  builder: (context, color, child) => ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      color ?? colors.icon,
                      BlendMode.srcIn,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: WaveText(
            widget.subtitle,
            type: WaveTextType.caption,
            color: MdColors.circleButtonSubtitleColor,
          ),
        )
      ],
    );
  }
}

enum WaveCircleButtonType { setting, leaveCall, startCall }

enum WaveCircleButtonState { normal, hover, pressed }

class CircleButtonColors {
  const CircleButtonColors({required this.background, required this.icon});
  final Color background;
  final Color icon;
}

CircleButtonColors _resolveCircleButtonColors(
  WaveCircleButtonType type,
  WaveCircleButtonState state,
  bool selected,
) {
  switch (type) {
    case WaveCircleButtonType.setting:
      return _resolveSetting(state: state, selected: selected);
    case WaveCircleButtonType.leaveCall:
      return _resolveLeaveCall(state);
    case WaveCircleButtonType.startCall:
      return _resolveStartCall(state);
  }
}

CircleButtonColors _resolveSetting({
  required WaveCircleButtonState state,
  required bool selected,
}) {
  switch (state) {
    case WaveCircleButtonState.normal:
      return CircleButtonColors(
        background: selected
            ? MdColors.circlebuttonSettingsDefaultSelectedBgColor
            : MdColors.circlebuttonSettingsDefaultUnselectedBgColor,
        icon: selected
            ? MdColors.circleButtonSettingsDefaultSelectedIconColor
            : MdColors.circleButtonSettingsDefaultUnselectedIconColor,
      );
    case WaveCircleButtonState.hover:
      return CircleButtonColors(
        background: selected
            ? MdColors.circleButtonSettingsHoverSelectedBgColor
            : MdColors.circleButtonSettingsHoverUnselectedBgColor,
        icon: selected
            ? MdColors.circleButtonSettingsHoverSelectedIconColor
            : MdColors.circleButtonSettingsHoverUnselectedIconColor,
      );
    case WaveCircleButtonState.pressed:
      return CircleButtonColors(
        background: selected
            ? MdColors.circleButtonSettingsPresseSelectedBgColor
            : MdColors.circleButtonSettingsPresseUnselectedBgColor,
        icon: selected
            ? MdColors.circleButtonSettingsPressedSelectedIconColor
            : MdColors.circleButtonSettingsPressedUnselectedIconColor,
      );
  }
}

CircleButtonColors _resolveLeaveCall(WaveCircleButtonState state) {
  switch (state) {
    case WaveCircleButtonState.normal:
      return const CircleButtonColors(
        background: MdColors.circleButtonLeaveCallDefaultBgColor,
        icon: MdColors.circleButtonLeaveCallDefaultIconColor,
      );
    case WaveCircleButtonState.hover:
      return const CircleButtonColors(
        background: MdColors.circleButtonLeaveCallHoverBgColor,
        icon: MdColors.circleButtonLeaveCallHoverIconColor,
      );
    case WaveCircleButtonState.pressed:
      return const CircleButtonColors(
        background: MdColors.circleButtonLeaveCallPressedBgColor,
        icon: MdColors.circleButtonLeaveCallPressedIconColor,
      );
  }
}

CircleButtonColors _resolveStartCall(WaveCircleButtonState state) {
  switch (state) {
    case WaveCircleButtonState.normal:
      return const CircleButtonColors(
        background: MdColors.circleButtonStartCallDefaultBgColor,
        icon: MdColors.circleButtonStartCallDefaultIconColor,
      );
    case WaveCircleButtonState.hover:
      return const CircleButtonColors(
        background: MdColors.circleButtonStartCallHoverBgColor,
        icon: MdColors.circleButtonStartCallHoverIconColor,
      );
    case WaveCircleButtonState.pressed:
      return const CircleButtonColors(
        background: MdColors.circleButtonStartCallPressedBgColor,
        icon: MdColors.circleButtonStartCallPressedIconColor,
      );
  }
}
