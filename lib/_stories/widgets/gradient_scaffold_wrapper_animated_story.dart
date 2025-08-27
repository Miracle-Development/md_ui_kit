import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/gradient_scaffold_wrapper_animated.dart';

class GradientScaffoldWrapperAnimatedStory extends StatefulWidget {
  const GradientScaffoldWrapperAnimatedStory({super.key});

  @override
  State<GradientScaffoldWrapperAnimatedStory> createState() =>
      _GradientScaffoldWrapperAnimatedStoryState();
}

class _GradientScaffoldWrapperAnimatedStoryState
    extends State<GradientScaffoldWrapperAnimatedStory> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GradientScaffoldWrapperAnimated(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
