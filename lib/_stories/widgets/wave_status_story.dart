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
    final type = knobs.options<WaveStatusType>(
      label: 'Type',
      initial: WaveStatusType.positive,
      options: const [
        Option(
          label: 'title',
          value: WaveStatusType.title,
        ),
        Option(
          label: 'subtitle',
          value: WaveStatusType.subtitle,
        ),
        Option(
          label: 'positive',
          value: WaveStatusType.positive,
        ),
        Option(
          label: 'negative',
          value: WaveStatusType.negative,
        ),
        Option(
          label: 'disabled',
          value: WaveStatusType.disabled,
        ),
        Option(
          label: 'brand',
          value: WaveStatusType.brand,
        ),
        Option(
          label: 'darkBrand',
          value: WaveStatusType.darkBrand,
        ),
      ],
    );
    return WaveStatus(
      type: type,
      label: label,
    );
  }
}
