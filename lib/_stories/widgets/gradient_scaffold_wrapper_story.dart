import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/gradient_scaffold_wrapper.dart';

class GradientScaffoldWrapperStory extends StatelessWidget {
  const GradientScaffoldWrapperStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientScaffoldWrapper(
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
