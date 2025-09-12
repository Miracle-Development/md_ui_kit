import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_chat_bubble.dart';
import 'package:md_ui_kit/widgets/wave_divider.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class WaveChatBubbleStory extends StatelessWidget {
  const WaveChatBubbleStory({
    super.key,
    required this.knobs,
  });

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    // Текст
    final label = knobs.text(
      label: 'Text',
      initial: 'Text',
    );

    final type = knobs.options<WaveChatBubbleType>(
        label: "Type",
        initial: WaveChatBubbleType.bubbleMessageOther,
        options: const [
          Option(
              label: "bubbleMessageOther",
              value: WaveChatBubbleType.bubbleMessageOther),
          Option(
              label: "bubbleMessageMe",
              value: WaveChatBubbleType.bubbleMessageMe),
          Option(
              label: "bubbleMessageInfo",
              value: WaveChatBubbleType.bubbleMessageInfo),
          Option(
              label: "bubbleMessageEvent",
              value: WaveChatBubbleType.bubbleMessageEvent)
        ]);

    final dividerType = knobs.options<WaveDividerType>(
      label: 'Divider Type (if used)',
      initial: WaveDividerType.title,
      options: const [
        Option(
          label: 'title',
          value: WaveDividerType.title,
        ),
        Option(
          label: 'subtitle',
          value: WaveDividerType.subtitle,
        ),
        Option(
          label: 'positive',
          value: WaveDividerType.positive,
        ),
        Option(
          label: 'negative',
          value: WaveDividerType.negative,
        ),
        Option(
          label: 'disabled',
          value: WaveDividerType.disabled,
        ),
        Option(
          label: 'brand',
          value: WaveDividerType.brand,
        ),
        Option(
          label: 'darkBrand',
          value: WaveDividerType.darkBrand,
        ),
      ],
    );

    return WaveChatBubble(
      type: type,
      label: label,
      dividerType: dividerType,
    );
  }
}
