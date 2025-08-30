import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_status.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class WaveStatusStory extends StatelessWidget {
  const WaveStatusStory({
    super.key,
    required this.knobs,
  });

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final label = knobs.text(
      label: 'Text',
      initial: 'Connected',
    );
    final type = knobs.options<WaveStatusColor>(
      label: 'Color',
      initial: WaveStatusColor.positiveColor,
      options: const [
        Option(
          label: 'titleColor',
          value: WaveStatusColor.titleColor,
        ),
        Option(
          label: 'subtitleColor',
          value: WaveStatusColor.subtitleColor,
        ),
        Option(
          label: 'positiveColor',
          value: WaveStatusColor.positiveColor,
        ),
        Option(
          label: 'negativeColor',
          value: WaveStatusColor.negativeColor,
        ),
        Option(
          label: 'disabledColor',
          value: WaveStatusColor.disabledColor,
        ),
        Option(
          label: 'brandColor',
          value: WaveStatusColor.brandColor,
        ),
        Option(
          label: 'darkBrandColor',
          value: WaveStatusColor.darkBrandColor,
        ),
      ],
    );
    return WaveStatus(color: type, label: label);
  }
}
