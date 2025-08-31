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
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double contentMaxWidth = (constraints.maxWidth -
              type.margin.horizontal -
              type.padding.horizontal);
          return Row(
            mainAxisAlignment: type == WaveChatBubbleType.bubbleMessageOther
                ? MainAxisAlignment.start
                : type == WaveChatBubbleType.bubbleMessageMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.center,
            children: [
              Container(
                padding: type.padding,
                margin: type.margin,
                decoration: BoxDecoration(
                  color: type.bgColor,
                  borderRadius: type.radius,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: type == WaveChatBubbleType.bubbleMessageEvent
                      ? WaveDivider(type: dividerType!, label: label)
                      : WaveText(
                          label,
                          type: WaveTextType.caption,
                          color: type.textColor,
                          maxLines: null,
                          overflow: TextOverflow.visible,
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

enum WaveChatBubbleType {
  bubbleMessageOther(
      padding: EdgeInsets.only(top: 8, right: 12, bottom: 8, left: 12),
      margin: EdgeInsets.only(left: 16, right: 48, bottom: 12),
      bgColor: MdColors.brandColor,
      textColor: Color.fromRGBO(255, 255, 255, 1),
      radius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(6),
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(6))),
  bubbleMessageMe(
      padding: EdgeInsets.only(top: 8, right: 12, bottom: 8, left: 12),
      margin: EdgeInsets.only(left: 48, right: 16, bottom: 12),
      bgColor: MdColors.brandColor,
      textColor: Color.fromRGBO(255, 255, 255, 1),
      radius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(6),
          bottomLeft: Radius.circular(12))),
  bubbleMessageInfo(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 12),
      bgColor: Colors.transparent,
      textColor: Color.fromRGBO(179, 179, 202, 1),
      radius: BorderRadius.zero),
  bubbleMessageEvent(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 12),
      bgColor: Colors.transparent,
      textColor: null,
      radius: BorderRadius.zero);

  const WaveChatBubbleType(
      {required this.padding,
      required this.margin,
      required this.bgColor,
      required this.radius,
      required this.textColor});
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BorderRadius radius;
  final Color bgColor;
  final Color? textColor;
}
