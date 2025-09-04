import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/_core/precached_icons.dart';

class WaveChatInput extends StatefulWidget {
  const WaveChatInput({
    super.key,
    this.controller,
    this.hintText,
    this.onSend,
    this.enabled = true,
    this.borderRadius = const BorderRadius.only(
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(6),
      topLeft: Radius.circular(6),
      topRight: Radius.circular(6),
    ),
    this.contentPadding =
        const EdgeInsets.only(top: 8, bottom: 8, right: 10, left: 10),
  });
  final BorderRadius borderRadius;
  final EdgeInsets contentPadding;
  final bool enabled;
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onSend;

  @override
  State<WaveChatInput> createState() => _WaveChatInoutState();
}

class _WaveChatInoutState extends State<WaveChatInput> {
  late final TextEditingController _controller;
  late final FocusNode _focus = FocusNode();
  bool _showArrow = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
    _controller = widget.controller ?? TextEditingController();
    _showArrow = _controller.text.isNotEmpty;
    _controller.addListener(() {
      final textNotEmpty = _controller.text.isNotEmpty;
      if (textNotEmpty != _showArrow) {
        setState(() {
          _showArrow = textNotEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focus.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    widget.onSend?.call(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = !widget.enabled
        ? MdColors.disabledInputColor
        : (_focus.hasFocus
            ? MdColors.selectedBorderInputColor
            : MdColors.defaultBorderInputColor);
    final enabledBorder = OutlineInputBorder(
      borderRadius: widget.borderRadius,
      borderSide: BorderSide(
        color: widget.enabled
            ? MdColors.defaultBorderInputColor
            : MdColors.disabledInputColor,
        width: 2,
      ),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: widget.borderRadius,
      borderSide: BorderSide(
        color: widget.enabled
            ? MdColors.selectedBorderInputColor
            : MdColors.disabledInputColor,
        width: 2,
      ),
    );
    final disabledBorder = OutlineInputBorder(
      borderRadius: widget.borderRadius,
      borderSide:
          const BorderSide(color: MdColors.disabledInputColor, width: 2),
    );

    final inputTextColor = widget.enabled
        ? MdColors.defaultTextInputColor
        : MdColors.disabledTextInputColor;

    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: MdColors.selectionTextInputColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 12,
                left: 20,
                top: 20,
              ),
              constraints: const BoxConstraints(minHeight: 32, maxHeight: 130),
              child: TextField(
                focusNode: _focus,
                controller: _controller,
                enabled: true,
                readOnly: !widget.enabled,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(
                  color: widget.enabled
                      ? MdColors.defaultTextInputColor
                      : MdColors.disabledInputColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Play',
                  letterSpacing: 1,
                ),
                cursorColor: inputTextColor,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: widget.contentPadding,
                  hoverColor: Colors.transparent,
                  fillColor: Colors.transparent,
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    color: MdColors.disabledTextInputColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Play',
                    letterSpacing: 1,
                  ),
                  enabledBorder: enabledBorder,
                  focusedBorder: focusedBorder,
                  disabledBorder: disabledBorder,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
            width: _showArrow ? 32 : 0,
            height: _showArrow ? 32 : 0,
            margin: const EdgeInsets.only(
              top: 20,
              right: 20,
              left: 12,
              bottom: 12,
            ),
            child: _showArrow
                ? Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(12),
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                      border: Border.all(
                        color: borderColor,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: IconButton(
                        iconSize: 24,
                        padding: EdgeInsets.zero,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: SvgPicture.asset(
                          PrecachedIcons.sendMsgIcon,
                          colorFilter:
                              ColorFilter.mode(borderColor, BlendMode.srcIn),
                        ),
                        onPressed: widget.enabled ? _handleSend : null,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
