import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:md_ui_kit/_core/colors.dart';

class WaveChatInput extends StatefulWidget {
  const WaveChatInput({
    super.key,
    this.contentPadding =
        const EdgeInsets.only(top: 8, bottom: 8, right: 10, left: 10),
    this.hintText,
    this.enabled = false,
    this.borderRadius = const BorderRadius.only(
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(6),
      topLeft: Radius.circular(6),
      topRight: Radius.circular(6),
    ),
    this.iconSize = 32,
    this.controller,
    this.onPressed,
  });

  final EdgeInsets contentPadding;
  final String? hintText;
  final bool enabled;
  final TextEditingController? controller;
  final BorderRadius borderRadius;
  final VoidCallback? onPressed;
  final double iconSize;

  @override
  State<WaveChatInput> createState() => _WaveChatInputState();
}

class _WaveChatInputState extends State<WaveChatInput> {
  final FocusNode _focus = FocusNode();

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var enabledBorder = OutlineInputBorder(
      borderRadius: widget.borderRadius,
      borderSide: const BorderSide(
        color: MdColors.defaultBorderInputColor,
        width: 2,
      ),
    );
    var focusedBorder = OutlineInputBorder(
      borderRadius: widget.borderRadius,
      borderSide: const BorderSide(
        color: MdColors.selectedBorderInputColor,
        width: 2,
      ),
    );
    var disabledBorder = OutlineInputBorder(
      borderRadius: widget.borderRadius,
      borderSide: const BorderSide(
        color: MdColors.disabledInputColor,
        width: 2,
      ),
    );

    final readOnly = !widget.enabled;
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: MdColors.selectionTextInputColor,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              padding: widget.contentPadding,
              constraints:
                  const BoxConstraints(minHeight: 32.0, maxHeight: 130.0),
              child: TextField(
                controller: widget.controller,
                focusNode: _focus,
                enabled: true,
                readOnly: readOnly,
                minLines: 1,
                maxLines: null,
                cursorHeight: 14,
                cursorColor: widget.enabled
                    ? MdColors.selectedBorderInputColor
                    : MdColors.disabledInputColor,
                style: TextStyle(
                  color: widget.enabled
                      ? MdColors.defaultTextInputColor
                      : MdColors.disabledInputColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Play',
                  letterSpacing: 1,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: widget.hintText ?? 'Type a message...',
                  enabledBorder:
                      widget.enabled ? enabledBorder : disabledBorder,
                  focusedBorder:
                      widget.enabled ? focusedBorder : disabledBorder,
                  disabledBorder: disabledBorder,
                  hoverColor: Colors.transparent,
                  fillColor: Colors.transparent,
                  hintStyle: const TextStyle(
                    color: MdColors.disabledTextInputColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Play',
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
