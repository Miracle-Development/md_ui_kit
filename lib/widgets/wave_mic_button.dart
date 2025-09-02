import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:md_ui_kit/_core/colors.dart' show MdColors;
import 'package:md_ui_kit/_core/precached_icons.dart';

class WaveMicButton extends StatefulWidget {
  const WaveMicButton({
    super.key,
    this.isMuted = false,
    this.duration = const Duration(milliseconds: 300),
    this.onTap,
  });

  final bool isMuted;
  final VoidCallback? onTap;
  final Duration duration;

  @override
  State<WaveMicButton> createState() => _WaveMicButtonState();
}

class _WaveMicButtonState extends State<WaveMicButton> {
  bool _muted = false;
  bool _hover = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _muted = widget.isMuted;
  }

  @override
  Widget build(BuildContext context) {
    final palette = _resolvePalette(
      muted: _muted,
      hover: _hover,
      pressed: _pressed,
    );
    return SizedBox(
      width: 112,
      height: 112,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() {
          _hover = false;
          _pressed = false;
        }),
        child: AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: palette.bg,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 60,
                offset: const Offset(0, 20),
                color: palette.shadow,
              ),
            ],
          ),
          child: InkWell(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) => setState(() => _pressed = false),
            onTap: () => setState(
              () {
                _muted = !_muted;
                if (widget.onTap != null) {
                  widget.onTap!();
                }
              },
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: AnimatedSwitcher(
              duration: widget.duration,
              child: SvgPicture.asset(
                PrecachedIcons.micButton,
                width: 112 * 0.41,
                height: 112 * 0.57,
                colorFilter: ColorFilter.mode(
                  palette.icon,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  MicPalette _resolvePalette({
    required bool muted,
    required bool hover,
    required bool pressed,
  }) {
    if (muted) {
      if (pressed) {
        return const MicPalette(
          bg: MdColors.mutedPressedBg,
          icon: MdColors.mutedPressedIcon,
          shadow: MdColors.mutedShadow,
        );
      }
      if (hover) {
        return const MicPalette(
          bg: MdColors.mutedHoverBg,
          icon: MdColors.mutedHoverIcon,
          shadow: MdColors.mutedShadow,
        );
      }
      return const MicPalette(
        bg: MdColors.mutedDefaultBg,
        icon: MdColors.mutedDefaultIcon,
        shadow: MdColors.mutedShadow,
      );
    } else {
      if (pressed) {
        return const MicPalette(
          bg: MdColors.unmutedPressedBg,
          icon: MdColors.unmutedPressedIcon,
          shadow: MdColors.unmutedShadow,
        );
      }
      if (hover) {
        return const MicPalette(
          bg: MdColors.unmutedHoverBg,
          icon: MdColors.unmutedHoverIcon,
          shadow: MdColors.unmutedShadow,
        );
      }
      return const MicPalette(
        bg: MdColors.unmutedDefaultBg,
        icon: MdColors.unmutedDefaultIcon,
        shadow: MdColors.unmutedShadow,
      );
    }
  }
}

class MicPalette {
  const MicPalette({
    required this.bg,
    required this.icon,
    required this.shadow,
  });

  final Color bg;
  final Color icon;
  final Color shadow;
}
