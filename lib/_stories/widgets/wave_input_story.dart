import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_input.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class WaveInputStory extends StatefulWidget {
  const WaveInputStory({super.key, required this.knobs});
  final KnobsBuilder knobs;

  @override
  State<WaveInputStory> createState() => _WaveInputStoryState();
}

class _WaveInputStoryState extends State<WaveInputStory> {
  final _controller = TextEditingController();
  String? _lastVariant;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  WaveInputType _mapVariantToType(String v) {
    switch (v) {
      case 'password':
        return WaveInputType.password;
      case 'code':
        return WaveInputType.code;
      case 'login':
      default:
        return WaveInputType.login;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hintText = widget.knobs.text(label: 'HintText', initial: 'some text');

    final variant = widget.knobs.options<String>(
      label: 'Type',
      initial: 'login',
      options: const [
        Option(label: 'login', value: 'login'),
        Option(label: 'password', value: 'password'),
        Option(label: 'code', value: 'code'),
      ],
    );

    final enabled = widget.knobs.boolean(label: 'Enabled', initial: true);
    final hasError = widget.knobs.boolean(label: 'hasError', initial: false);

    if (_lastVariant != variant) {
      _lastVariant = variant;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.clear();
      });
    }

    final type = _mapVariantToType(variant);

    return WaveInput(
      type: type,
      enabled: enabled,
      hasError: hasError,
      hintText: hintText,
      controller: _controller,
    );
  }
}
