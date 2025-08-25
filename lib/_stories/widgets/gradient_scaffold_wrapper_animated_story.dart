import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/gradient_scaffold_wrapper_animated.dart';

class GradientScaffoldWrapperAnimatedStory extends StatelessWidget {
  const GradientScaffoldWrapperAnimatedStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientScaffoldWrapperAnimated(
      child: Center(
        child: Text(
          'Widget goes here',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
