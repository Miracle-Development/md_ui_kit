import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/md_ui_kit.dart';

class WaveChatBubble extends StatelessWidget {
  const WaveChatBubble(
      {super.key, required this.type, required this.label, this.dividerType});

  final WaveChatBubbleType type;
  final String label;
  final WaveDividerType? dividerType;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: type.padding,
        decoration:
            BoxDecoration(color: type.bgColor, borderRadius: type.radius),
        child: type == WaveChatBubbleType.bubbleMessageEvent
            ? WaveDivider(type: dividerType!, label: label)
            : WaveText(label,
                type: WaveTextType.caption, color: type.textColor));
  }
}

enum WaveChatBubbleType {
  bubbleMessageOther(
      padding: EdgeInsets.only(left: 16, right: 48, bottom: 12),
      bgColor: MdColors.brandColor,
      textColor: Color.fromRGBO(255, 255, 255, 1),
      radius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(6),
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(6))),
  bubbleMessageMe(
      padding: EdgeInsets.only(left: 48, right: 16, bottom: 12),
      bgColor: MdColors.brandColor,
      textColor: Color.fromRGBO(255, 255, 255, 1),
      radius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(6),
          bottomLeft: Radius.circular(12))),
  bubbleMessageInfo(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
      bgColor: Colors.transparent,
      textColor: Color.fromRGBO(179, 179, 202, 1),
      radius: BorderRadius.zero),
  bubbleMessageEvent(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
      bgColor: Colors.transparent,
      textColor: null,
      radius: BorderRadius.zero);

  const WaveChatBubbleType(
      {required this.padding,
      required this.bgColor,
      required this.radius,
      required this.textColor});
  final EdgeInsets padding;
  final BorderRadius radius;
  final Color bgColor;
  final Color? textColor;
}
