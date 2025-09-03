import 'dart:math' as math;
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

class _WaveMicButtonState extends State<WaveMicButton>
    with SingleTickerProviderStateMixin {
  bool _muted = false;
  bool _hover = false;
  bool _pressed = false;

  late final AnimationController _anumationController;
  bool _animating = false;

  static const double _btnSize = 112;
  static const double _lineLength = 54;
  static const double _lineThickness = 5;
  static const Color _lineColor = MdColors.micLineColor;

  @override
  void initState() {
    super.initState();
    _muted = widget.isMuted;

    _anumationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _anumationController.value = _muted ? 1.0 : 0.0;

    _anumationController.addStatusListener((status) {
      final anim = status == AnimationStatus.forward ||
          status == AnimationStatus.reverse;
      if (anim != _animating) {
        setState(() => _animating = anim);
      }
    });
  }

  @override
  void didUpdateWidget(covariant WaveMicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMuted != oldWidget.isMuted) {
      _muted = widget.isMuted;
      _anumationController.value = _muted ? 1.0 : 0.0;
    }
  }

  @override
  void dispose() {
    _anumationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = _resolvePalette(
      muted: _muted,
      hover: _hover,
      pressed: _pressed,
    );
    return SizedBox(
      width: _btnSize,
      height: _btnSize,
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
            onTapDown:
                _animating ? null : (_) => setState(() => _pressed = true),
            onTapCancel:
                _animating ? null : () => setState(() => _pressed = false),
            onTapUp:
                _animating ? null : (_) => setState(() => _pressed = false),
            onTap: _animating
                ? null
                : () => setState(() {
                      _muted = !_muted;
                      if (_muted) {
                        _anumationController.forward();
                      } else {
                        _anumationController.reverse();
                      }

                      widget.onTap;
                    }),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedSwitcher(
                  duration: widget.duration,
                  child: SvgPicture.asset(
                    PrecachedIcons.micButton,
                    key: ValueKey(_muted),
                    width: _btnSize * 0.41,
                    height: _btnSize * 0.57,
                    colorFilter: ColorFilter.mode(
                      palette.icon,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                if (_anumationController.value > 0.0 || _muted)
                  _Line(
                    controller: _anumationController,
                    length: _lineLength,
                    thickness: _lineThickness,
                    color: _lineColor,
                  ),
              ],
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

class _Line extends StatelessWidget {
  const _Line({
    required this.controller,
    required this.length,
    required this.thickness,
    required this.color,
  });

  final AnimationController controller;
  final double length;
  final double thickness;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final Animation<double> progress =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        final status = controller.status;
        final align = (status == AnimationStatus.reverse)
            ? Alignment.centerLeft
            : Alignment.centerRight;

        return Transform.rotate(
          angle: -45 * (math.pi / 180.0),
          child: SizedBox(
            width: length,
            height: thickness,
            child: Align(
                alignment: align,
                child: ClipRect(
                  child: Align(
                    alignment: align,
                    widthFactor: progress.value,
                    child: Container(
                      width: length,
                      height: thickness,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: color,
                      ),
                    ),
                  ),
                )),
          ),
        );
      },
    );
  }
}
