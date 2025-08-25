import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

@immutable
class MdTextButtonTheme extends ThemeExtension<MdTextButtonTheme> {
  const MdTextButtonTheme({
    required this.defaultColor,
    required this.hoverColor,
    required this.pressedColor,
    required this.disabledColor,
  });

  final Color defaultColor;
  final Color hoverColor;
  final Color pressedColor;
  final Color disabledColor;

  static const MdTextButtonTheme fallback = MdTextButtonTheme(
    defaultColor: Color.fromRGBO(220, 218, 255, 1),
    hoverColor: Color.fromRGBO(177, 172, 255, 1),
    pressedColor: Color.fromRGBO(67, 70, 243, 1),
    disabledColor: Color.fromRGBO(116, 115, 140, 1),
  );

  @override
  MdTextButtonTheme copyWith({
    Color? defaultColor,
    Color? hoverColor,
    Color? pressedColor,
    Color? disabledColor,
  }) {
    return MdTextButtonTheme(
      defaultColor: defaultColor ?? this.defaultColor,
      hoverColor: hoverColor ?? this.hoverColor,
      pressedColor: pressedColor ?? this.pressedColor,
      disabledColor: disabledColor ?? this.disabledColor,
    );
  }

  @override
  MdTextButtonTheme lerp(ThemeExtension<MdTextButtonTheme>? other, double t) {
    if (other is! MdTextButtonTheme) return this;
    return MdTextButtonTheme(
      defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t)!,
      pressedColor: Color.lerp(pressedColor, other.pressedColor, t)!,
      disabledColor: Color.lerp(disabledColor, other.disabledColor, t)!,
    );
  }

  static MdTextButtonTheme of(BuildContext context) =>
      Theme.of(context).extension<MdTextButtonTheme>() ?? fallback;
}

enum _BtnState { normal, hover, pressed, disabled }

class MdTextButton extends StatefulWidget {
  const MdTextButton({
    super.key,
    this.label = "test-peer",
    this.onPressed,
    this.enabled = true,
  });

  final String label;

  final VoidCallback? onPressed;
  final bool enabled;

  static const String _iconAssetDefault = 'assets/icons/code/code_default.svg';
  static const String _iconAssetPressed = 'assets/icons/code/code_pressed.svg';
  static const double _iconSize = 32;

  @override
  State<MdTextButton> createState() => _MdTextButtonState();
}

class _MdTextButtonState extends State<MdTextButton> {
  bool _hover = false;
  bool _pressed = false;
  Timer? _pressedTimer;

  _BtnState get _state {
    if (!widget.enabled || widget.onPressed == null) return _BtnState.disabled;
    if (_pressed) return _BtnState.pressed;
    if (_hover) return _BtnState.hover;
    return _BtnState.normal;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(MdTextButton._iconAssetDefault), context);
    precacheImage(const AssetImage(MdTextButton._iconAssetPressed), context);
  }

  @override
  void dispose() {
    _pressedTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = MdTextButtonTheme.of(context);

    // цвет текста/иконки по состоянию
    final Color color = switch (_state) {
      _BtnState.normal => t.defaultColor,
      _BtnState.hover => t.hoverColor,
      _BtnState.pressed => t.pressedColor,
      _BtnState.disabled => t.disabledColor,
    };

    final Widget baseText = Text(
      widget.label,
      style: TextStyle(
        fontFamily: 'Play',
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color,
      ),
    );

    final String iconAsset = _state == _BtnState.pressed
        ? MdTextButton._iconAssetPressed
        : MdTextButton._iconAssetDefault;

    final Widget trailing = AnimatedSwitcher(
      duration: const Duration(milliseconds: 120),
      child: SvgPicture.asset(
        iconAsset,
        width: MdTextButton._iconSize,
        height: MdTextButton._iconSize,
        color: color,
      ),
    );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        baseText,
        const SizedBox(width: 12),
        trailing,
      ],
    );

    final decorated = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeInOut,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Center(child: content),
    );

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 197,
        height: 28,
        child: InkWell(
          onTap: (widget.enabled && widget.onPressed != null)
              ? () {
                  setState(() => _pressed = true);
                  widget.onPressed?.call();
                  _pressedTimer?.cancel();
                  _pressedTimer = Timer(const Duration(seconds: 1), () {
                    if (!mounted) return;
                    setState(() => _pressed = false);
                  });
                }
              : null,
          onHover: (v) => setState(() => _hover = v),
          onHighlightChanged: (v) {
            if (v) setState(() => _pressed = true);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          enableFeedback: false,
          child: decorated,
        ),
      ),
    );
  }
}
