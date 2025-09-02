import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_input.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class WaveInputStory extends StatelessWidget {
  const WaveInputStory({super.key, required this.knobs});
  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final hintText = knobs.text(label: "HintText", initial: "some text");
    final type = knobs.options<WaveInputType>(
      label: 'Style',
      initial: WaveInputType.login,
      options: const [
        Option(
          label: 'login',
          value: WaveInputType.login,
        ),
        Option(
          label: 'password',
          value: WaveInputType.password,
        ),
        Option(label: "code", value: WaveInputType.code)
      ],
    );
    final enabled = knobs.boolean(
      label: 'Enabled',
      initial: true,
    );
    final hasError = knobs.boolean(
      label: 'hasError',
      initial: false,
    );

    return WaveInput(
      type: type,
      enabled: enabled,
      hasError: hasError,
      hintText: hintText,
    );
  }
}
