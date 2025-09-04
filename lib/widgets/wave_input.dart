import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:md_ui_kit/_core/colors.dart' show MdColors;
import 'package:md_ui_kit/_core/precached_icons.dart';

class WaveInput extends StatefulWidget {
  const WaveInput({
    super.key,
    required this.type,
    this.contentPadding = const EdgeInsets.only(
      top: 10,
      right: 20,
      bottom: 10,
      left: 20,
    ),
    this.enabled = true,
    this.hasError = false,
    this.controller,
    this.hintText,
  });

  final WaveInputType type;
  final EdgeInsets contentPadding;
  final bool enabled;
  final bool hasError;
  final TextEditingController? controller;
  final String? hintText;

  @override
  State<WaveInput> createState() => _WaveInputState();
}

class _WaveInputState extends State<WaveInput> {
  bool obscure = true;
  late final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WaveInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.type != widget.type) {
      obscure = widget.type == WaveInputType.password ? true : false;
    }
  }

  List<TextInputFormatter> _formattersFor(WaveInputType t) {
    final denySpaces = FilteringTextInputFormatter.deny(RegExp(r'\s'));
    switch (t) {
      case WaveInputType.login:
        {
          final allowChars =
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9.\-@]'));
          final emailShape =
              TextInputFormatter.withFunction((oldValue, newValue) {
            final s = newValue.text;

            if (s.isEmpty) return newValue;

            if (s.startsWith('.')) return oldValue;

            if (RegExp(r'@').allMatches(s).length > 1) return oldValue;

            final at = s.indexOf('@');

            if (at == 0) return oldValue;

            if (s.contains('..')) return oldValue;

            if (at > 0) {
              final prefix = s.substring(0, at);
              if (!RegExp(r'^[A-Za-z0-9.\-]+$').hasMatch(prefix)) {
                return oldValue;
              }
              if (prefix.endsWith('.')) return oldValue;
            }
            if (at >= 0) {
              final domain = s.substring(at + 1);
              if (domain.isNotEmpty) {
                if (domain.startsWith('.')) return oldValue;

                final firstDot = domain.indexOf('.');
                if (firstDot != -1) {
                  if (domain.indexOf('.', firstDot + 1) != -1) return oldValue;
                }
              }
            }

            return newValue;
          });
          return [denySpaces, allowChars, emailShape];
        }
      case WaveInputType.password:
        return [
          denySpaces,
          FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\?\!\,\.]")),
        ];
      case WaveInputType.code:
        {
          final allowChars =
              FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\-]"));
          final codeShape =
              TextInputFormatter.withFunction((oldValue, newValue) {
            final s = newValue.text;

            if (s.isEmpty) return newValue;

            if (s.startsWith('-')) return oldValue;

            if (RegExp(r'-').allMatches(s).length > 1) return oldValue;

            final at = s.indexOf('@');

            if (at == 0) return oldValue;

            if (s.contains('--')) return oldValue;

            return newValue;
          });
          return [denySpaces, allowChars, codeShape];
        }
    }
  }

  String _defaultHint(WaveInputType t) {
    switch (t) {
      case WaveInputType.login:
        return 'mylogin';
      case WaveInputType.password:
        return 'password';
      case WaveInputType.code:
        return 'code';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.type == WaveInputType.password;
    Widget? suffixIcon;
    if (isPassword) {
      final iconColor = widget.enabled
          ? MdColors.defaultTextInputColor
          : MdColors.disabledInputColor;

      final icon = !obscure
          ? SvgPicture.asset(
              PrecachedIcons.inputOpenedEyeIcon,
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            )
          : SvgPicture.asset(
              PrecachedIcons.inputClosedEyeIcon,
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            );
      suffixIcon = IconButton(
        onPressed:
            widget.enabled ? () => setState(() => obscure = !obscure) : null,
        icon: icon,
        padding: const EdgeInsets.only(right: 20, top: 8, bottom: 8, left: 12),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      );
    }
    const enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(
        color: MdColors.defaultBorderInputColor,
        width: 2,
      ),
    );
    const focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(
        color: MdColors.selectedBorderInputColor,
        width: 2,
      ),
    );
    const errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(
        color: MdColors.errorInputColor,
        width: 2,
      ),
    );
    const disabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(
        color: MdColors.disabledInputColor,
        width: 2,
      ),
    );
    final effectiveEnabledBorder =
        widget.hasError ? errorBorder : enabledBorder;
    final effectiveFocusedBorder =
        widget.hasError ? errorBorder : focusedBorder;
    final hasCustomHint = (widget.hintText?.trim().isNotEmpty ?? false);
    final String? effectiveHint =
        (hasCustomHint ? widget.hintText : _defaultHint(widget.type));
    final readOnly = !widget.enabled;

    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: MdColors.selectionTextInputColor,
        ),
      ),
      child: SizedBox(
        height: 48,
        child: TextField(
          focusNode: _focus,
          controller: widget.controller,
          enabled: true,
          readOnly: readOnly,
          cursorHeight: 20,
          inputFormatters: _formattersFor(widget.type),
          keyboardType: switch (widget.type) {
            WaveInputType.login => TextInputType.emailAddress,
            WaveInputType.password => TextInputType.visiblePassword,
            WaveInputType.code => TextInputType.text,
          },
          obscureText: isPassword && obscure,
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
            letterSpacing: 1,
          ),
          decoration: InputDecoration(
            hoverColor: Colors.transparent,
            fillColor: Colors.transparent,
            contentPadding: widget.contentPadding,
            hintText: effectiveHint,
            hintStyle: const TextStyle(
              color: MdColors.disabledTextInputColor,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Play',
              letterSpacing: 1,
            ),
            enabledBorder:
                widget.enabled ? effectiveEnabledBorder : disabledBorder,
            focusedBorder:
                widget.enabled ? effectiveFocusedBorder : disabledBorder,
            errorBorder: errorBorder,
            disabledBorder: disabledBorder,
            suffixIcon: suffixIcon,
          ),
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
