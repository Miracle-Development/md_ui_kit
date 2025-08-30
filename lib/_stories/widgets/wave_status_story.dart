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
    final type = knobs.options<WaveStatusType>(
      label: 'Type',
      initial: WaveStatusType.failed,
      options: const [
        Option(
          label: 'failed',
          value: WaveStatusType.failed,
        ),
        Option(
          label: 'success',
          value: WaveStatusType.success,
        ),
        Option(
          label: 'process',
          value: WaveStatusType.process,
        ),
        Option(
          label: 'done',
          value: WaveStatusType.done,
        ),
      ],
    );
    return WaveStatus(type: type);
  }
}
