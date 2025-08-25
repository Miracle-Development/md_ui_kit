import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/gradient_background.dart';

class GradientBackgroundStory extends StatelessWidget {
  const GradientBackgroundStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientBackground(
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
