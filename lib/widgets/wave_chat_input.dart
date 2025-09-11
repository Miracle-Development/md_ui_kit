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
    this.borderRadiusContent = const BorderRadius.only(
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(6),
      topLeft: Radius.circular(6),
      topRight: Radius.circular(6),
    ),
    this.borderRadiusNoContent = const BorderRadius.only(
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(6),
      topLeft: Radius.circular(6),
      topRight: Radius.circular(12),
    ),
    this.contentPadding =
        const EdgeInsets.only(top: 8, bottom: 8, right: 10, left: 10),
  });
  final BorderRadius borderRadiusContent;
  final BorderRadius borderRadiusNoContent;
  final EdgeInsets contentPadding;
  final bool enabled;
  final TextEditingController? controller;
  final String? hintText;
  final VoidCallback? onSend;

  @override
  State<WaveChatInput> createState() => _WaveChatInoutState();
}

class _WaveChatInoutState extends State<WaveChatInput> {
  late final TextEditingController _controller;
  late final FocusNode _focus = FocusNode();
  bool _showArrow = false;
  bool _iconHover = false;
  bool _iconPressed = false;

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
    widget.onSend?.call();
    _controller.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  Color _resolveIconColor() {
    if (_iconPressed) {
      return MdColors.pressedIconChatInputColor;
    } else if (_iconHover) {
      return MdColors.hoverIconChatInputColor;
    }
    return MdColors.defaultIconChatInputColor;
  }

  @override
  Widget build(BuildContext context) {
    final enabledBorder = OutlineInputBorder(
      borderRadius: _controller.text.isEmpty
          ? widget.borderRadiusNoContent
          : widget.borderRadiusContent,
      borderSide: BorderSide(
        color: !widget.enabled
            ? MdColors.disabledChatInputColor
            : _controller.text.trim().isEmpty
                ? MdColors.disabledChatInputColor
                : MdColors.defaultBorderChatInputColor,
        width: 2,
      ),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: _controller.text.isEmpty
          ? widget.borderRadiusNoContent
          : widget.borderRadiusContent,
      borderSide: BorderSide(
        color: widget.enabled
            ? MdColors.selectedBorderChatInputColor
            : MdColors.disabledChatInputColor,
        width: 2,
      ),
    );
    final disabledBorder = OutlineInputBorder(
      borderRadius: _controller.text.isEmpty
          ? widget.borderRadiusNoContent
          : widget.borderRadiusContent,
      borderSide:
          const BorderSide(color: MdColors.disabledChatInputColor, width: 2),
    );

    final inputTextColor = widget.enabled
        ? MdColors.defaultTextChatInputColor
        : MdColors.disabledTextChatInputColor;

    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: MdColors.selectionTextChatInputColor,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(17, 17, 30, 0.95),
                  ),
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                  padding: EdgeInsets.only(
                    left: 20,
                    top: 20,
                    bottom: 12,
                    right: _showArrow ? 12 : 20,
                  ),
                  child: ClipRRect(
                    borderRadius: _controller.text.isEmpty
                        ? widget.borderRadiusNoContent
                        : widget.borderRadiusContent,
                    child: Container(
                      constraints:
                          const BoxConstraints(minHeight: 32, maxHeight: 130),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(17, 17, 30, 0.9),
                      ),
                      child: TextField(
                        focusNode: _focus,
                        controller: _controller,
                        enabled: true,
                        readOnly: !widget.enabled,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(
                          color: widget.enabled
                              ? MdColors.defaultTextChatInputColor
                              : MdColors.disabledChatInputColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Play',
                          letterSpacing: 1,
                        ),
                        cursorColor: inputTextColor,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          filled: true,
                          contentPadding: widget.contentPadding,
                          hoverColor: Colors.transparent,
                          fillColor: Colors.transparent,
                          hintText: widget.hintText,
                          hintStyle: const TextStyle(
                            color: MdColors.disabledTextChatInputColor,
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
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
                width: _showArrow ? 32 : 0,
                height: 32,
                margin: const EdgeInsets.only(
                  top: 20,
                  right: 20,
                  bottom: 12,
                ),
                child: IgnorePointer(
                  ignoring: !_showArrow || !widget.enabled,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.ease,
                    opacity: (_showArrow && widget.enabled) ? 1 : 0,
                    child: _showArrow && widget.enabled
                        ? MouseRegion(
                            onEnter: (_) => setState(() => _iconHover = true),
                            onExit: (_) => setState(() => _iconHover = false),
                            child: GestureDetector(
                              onTapDown: (_) =>
                                  setState(() => _iconPressed = true),
                              onTapUp: (_) =>
                                  setState(() => _iconPressed = false),
                              onTapCancel: () =>
                                  setState(() => _iconPressed = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                curve: Curves.ease,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(12),
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                  color: const Color.fromRGBO(17, 17, 30, 0.9),
                                  border: Border.all(
                                    color: _resolveIconColor(),
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
                                      colorFilter: ColorFilter.mode(
                                          _resolveIconColor(), BlendMode.srcIn),
                                    ),
                                    onPressed:
                                        widget.enabled ? _handleSend : null,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
