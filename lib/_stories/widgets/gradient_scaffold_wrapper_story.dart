import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/gradient_scaffold_wrapper.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class GradientScaffoldWrapperStory extends StatefulWidget {
  const GradientScaffoldWrapperStory({super.key, required this.knobs});

  final KnobsBuilder knobs;

  @override
  State<GradientScaffoldWrapperStory> createState() =>
      _GradientScaffoldWrapperStoryState();
}

class _GradientScaffoldWrapperStoryState
    extends State<GradientScaffoldWrapperStory> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    final showScroll =
        context.knobs.boolean(label: 'Show Scroll', initial: false);

    return GradientScaffoldWrapper(
      child: showScroll
          ? Column(
              children: [
                for (int i = 0; i < 80; i++) Text('text example $i'),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTapUp: (_) => setState(() => _isPressed = false),
                    onTapDown: (_) => setState(() => _isPressed = true),
                    onTapCancel: () => setState(() => _isPressed = false),
                    onTap: () => print('Tapped'),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Widget goes here',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _isPressed ? Colors.blueGrey : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
