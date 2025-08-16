import 'package:flutter/material.dart';
import 'package:md_ui_kit/stories/md_text_story/md_text_story.dart';
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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF141218),
      ),
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          child: Storybook(
            wrapperBuilder: (context, child) {
              if (child == null) return const SizedBox();

              return Center(child: child);
            },
            stories: [
              Story(
                name: 'Widgets/Text',
                builder: (context) => MdTextStory(knobs: context.knobs),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
