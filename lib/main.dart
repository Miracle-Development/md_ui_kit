import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/theme.dart';
import 'package:md_ui_kit/_stories/screens/counter_screen_story.dart';
import 'package:md_ui_kit/_stories/widgets/md_text_story.dart';
import 'package:md_ui_kit/widgets/md_initial_wave.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

void main() {
  runApp(const StorybookApp());
}

class StorybookApp extends StatelessWidget {
  const StorybookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // darkTheme: AppTheme.dark, // Uncomment to use the dark theme
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          child: Storybook(
            wrapperBuilder: (context, child) {
              if (child == null) return const SizedBox();

              return Center(child: child);
            },
            stories: [
              // Screens
              Story(
                name: 'Screens/Counter',
                builder: (context) => CounterScreenStory(knobs: context.knobs),
              ),
              Story(
                name: 'Text', // Widgets/Text to create a folderable structure
                builder: (context) => MdTextStory(knobs: context.knobs),
              ),
              Story(
                name:
                    'Wave/MdInitialWave', // Widgets/Text to create a folderable structure
                builder: (context) => const MdInitialWave(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
