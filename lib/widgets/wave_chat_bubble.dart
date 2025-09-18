import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/md_ui_kit.dart';

class WaveChatBubble extends StatelessWidget {
  const WaveChatBubble({
    super.key,
    required this.type,
    required this.label,
    this.dividerType = WaveDividerType.brand,
  });

  final WaveChatBubbleType type;
  final String label;
  final WaveDividerType? dividerType;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: MdColors.selectionChatBubbleColor,
        ),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final double maxAvailable = constraints.maxWidth;
        final double contentMaxWidth = (maxAvailable -
            type.margin.horizontal -
            type.padding.horizontal -
            16);

        return Row(
          mainAxisAlignment: type == WaveChatBubbleType.bubbleMessageOther
              ? MainAxisAlignment.start
              : type == WaveChatBubbleType.bubbleMessageMe
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                padding: type.padding,
                margin: type.margin,
                decoration: BoxDecoration(
                  color: type.bgColor,
                  borderRadius: type.radius,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: type == WaveChatBubbleType.bubbleMessageEvent
                      ? WaveDivider(
                          type: dividerType!,
                          label: label,
                        )
                      : WaveText(
                          label,
                          type: WaveTextType.caption,
                          color: type.textColor,
                          selectable: true,
                          overflow: TextOverflow.clip,
                          textAlign:
                              type == WaveChatBubbleType.bubbleMessageInfo
                                  ? TextAlign.center
                                  : null,
                        ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

enum WaveChatBubbleType {
  bubbleMessageOther(
    padding: EdgeInsets.only(
      top: 8,
      right: 12,
      bottom: 8,
      left: 12,
    ),
    margin: EdgeInsets.only(
      left: 16,
      right: 48,
      bottom: 12,
    ),
    bgColor: MdColors.chatBubbleColorOther,
    textColor: MdColors.chatBubbleColorText,
    radius: BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomRight: Radius.circular(12),
      bottomLeft: Radius.circular(6),
    ),
  ),
  bubbleMessageMe(
    padding: EdgeInsets.only(
      top: 8,
      right: 12,
      bottom: 8,
      left: 12,
    ),
    margin: EdgeInsets.only(
      left: 48,
      right: 16,
      bottom: 12,
    ),
    bgColor: MdColors.chatBubbleColorMe,
    textColor: MdColors.chatBubbleColorText,
    radius: BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomRight: Radius.circular(6),
      bottomLeft: Radius.circular(12),
    ),
  ),
  bubbleMessageInfo(
    padding: EdgeInsets.zero,
    margin: EdgeInsets.only(
      left: 16,
      right: 16,
      bottom: 12,
    ),
    bgColor: Colors.transparent,
    textColor: MdColors.chatBubbleColorSystem,
    radius: BorderRadius.zero,
  ),
  bubbleMessageEvent(
    padding: EdgeInsets.zero,
    margin: EdgeInsets.only(
      left: 16,
      right: 16,
      bottom: 12,
    ),
    bgColor: Colors.transparent,
    textColor: null,
    radius: BorderRadius.zero,
  );

  const WaveChatBubbleType({
    required this.padding,
    required this.margin,
    required this.bgColor,
    required this.radius,
    required this.textColor,
  });

  final EdgeInsets padding;
  final EdgeInsets margin;
  final BorderRadius radius;
  final Color bgColor;
  final Color? textColor;
}
