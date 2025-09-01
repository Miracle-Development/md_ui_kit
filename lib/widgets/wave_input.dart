import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:md_ui_kit/_core/colors.dart' show MdColors;
import 'package:md_ui_kit/_core/precached_icons.dart';

class WaveInput extends StatefulWidget {
  const WaveInput({
    super.key,
    required this.type,
    this.contentPadding =
        const EdgeInsets.only(top: 10, right: 20, bottom: 10, left: 20),
    this.enabled = true,
    this.hasError = false,
    this.controller,
  });

  final WaveInputType type;
  final EdgeInsets contentPadding;
  final bool enabled;
  final bool hasError;
  final TextEditingController? controller;

  @override
  State<WaveInput> createState() => _WaveInputState();
}

class _WaveInputState extends State<WaveInput> {
  bool obscure = false;

  @override
  Widget build(BuildContext context) {
    Widget? suffixIcon;
    if (widget.type == WaveInputType.password) {
      final icon = obscure
          ? Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  PrecachedIcons.visible,
                  width: 32,
                  height: 32,
                  colorFilter: ColorFilter.mode(
                      widget.enabled
                          ? MdColors.defaultTextInputColor
                          : MdColors.disabledInputColor,
                      BlendMode.srcIn),
                ),
                SvgPicture.asset(
                  PrecachedIcons.invisibleLine,
                  width: 32,
                  height: 32,
                  colorFilter: ColorFilter.mode(
                      widget.enabled
                          ? MdColors.defaultTextInputColor
                          : MdColors.disabledInputColor,
                      BlendMode.srcIn),
                ),
              ],
            )
          : SvgPicture.asset(
              PrecachedIcons.visible,
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                  widget.enabled
                      ? MdColors.defaultTextInputColor
                      : MdColors.disabledInputColor,
                  BlendMode.srcIn),
            );

      suffixIcon = IconButton(
        onPressed:
            widget.enabled ? () => setState(() => obscure = !obscure) : null,
        icon: icon,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      );
    }
    const enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: MdColors.defaultBorderInputColor, width: 2),
    );
    const focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide:
          BorderSide(color: MdColors.selectedBorderInputColor, width: 2),
    );
    const errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: MdColors.errorInputColor, width: 2),
    );
    const disabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: MdColors.disabledInputColor, width: 2),
    );
    final effectiveEnabledBorder =
        widget.hasError ? errorBorder : enabledBorder;
    final effectiveFocusedBorder =
        widget.hasError ? errorBorder : focusedBorder;

    return Theme(
      data: Theme.of(context).copyWith(
          textSelectionTheme: const TextSelectionThemeData(
              selectionColor: MdColors.selectionTextInputColor)),
      child: TextField(
        controller: widget.controller,
        enabled: widget.enabled,
        obscureText: obscure,
        obscuringCharacter: '*',
        cursorColor: widget.enabled
            ? MdColors.defaultTextInputColor
            : MdColors.disabledInputColor,
        textAlign: widget.type.textAlign,
        style: TextStyle(
          color: widget.enabled
              ? MdColors.defaultTextInputColor
              : MdColors.disabledInputColor,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          fontFamily: 'Play',
        ),
        decoration: InputDecoration(
          hoverColor: Colors.transparent,
          fillColor: Colors.transparent,
          contentPadding: widget.contentPadding,
          enabledBorder: effectiveEnabledBorder,
          focusedBorder: effectiveFocusedBorder,
          errorBorder: errorBorder,
          disabledBorder: disabledBorder,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

enum WaveInputType {
  login(textAlign: TextAlign.start),
  password(textAlign: TextAlign.start),
  code(textAlign: TextAlign.center);

  const WaveInputType({required this.textAlign});
  final TextAlign textAlign;
}
