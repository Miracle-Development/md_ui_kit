import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/precached_icons.dart';
import 'package:md_ui_kit/_core/theme.dart';
import 'package:md_ui_kit/_stories/screens/counter_screen_story.dart';
import 'package:md_ui_kit/_stories/screens/initial_screen_story.dart';
import 'package:md_ui_kit/_stories/widgets/blurred_circle_story.dart';
import 'package:md_ui_kit/_stories/widgets/gradient_background_story.dart';
import 'package:md_ui_kit/_stories/widgets/gradient_scaffold_wrapper_animated_story.dart';
import 'package:md_ui_kit/_stories/widgets/gradient_scaffold_wrapper_story.dart';
import 'package:md_ui_kit/_stories/widgets/wave_chat_bubble_story.dart';
import 'package:md_ui_kit/_stories/widgets/wave_divider_story.dart';
import 'package:md_ui_kit/_stories/widgets/wave_mic_button_story.dart';
import 'package:md_ui_kit/_stories/widgets/wave_simple_button_story.dart';
import 'package:md_ui_kit/_stories/widgets/wave_status_story.dart';
import 'package:md_ui_kit/_stories/widgets/wave_item_badge_story.dart';
import 'package:md_ui_kit/_stories/widgets/wave_nav_bar_item_story.dart';
import 'package:md_ui_kit/_stories/widgets/wave_text_story.dart';
import 'package:md_ui_kit/_stories/widgets/wave_text_button_story.dart';
import 'package:md_ui_kit/widgets/md_initial_wave.dart';
import 'package:md_ui_kit/widgets/wave_logo.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const StorybookApp());
}

class StorybookApp extends StatelessWidget {
  const StorybookApp({super.key});

  @override
  Widget build(BuildContext context) {
    const PrecachedIcons().precache(context);

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
              // Other
              Story(
                name: 'Other/Counter',
                builder: (context) => CounterScreenStory(knobs: context.knobs),
              ),
              // Wave
              Story(
                name: 'Wave/WaveText',
                builder: (context) => WaveTextStory(knobs: context.knobs),
              ),
              Story(
                name: 'Wave/WaveTextButton',
                builder: (context) => MdTextButtonStory(knobs: context.knobs),
              ),
              Story(
                name: 'Wave/WaveSimpleButton',
                builder: (context) =>
                    WaveSimpleButtonStory(knobs: context.knobs),
              ),
              Story(
                name: 'Wave/WaveItemBadge',
                builder: (context) => WaveItemBadgeStory(knobs: context.knobs),
              ),
              Story(
                name: 'Wave/WaveNavBarItem',
                builder: (context) => WaveNavBarItemStory(knobs: context.knobs),
              ),
              Story(
                name: 'Wave/WaveLogo',
                builder: (context) => const WaveLogo(),
              ),
              Story(
                name: 'Wave/MdInitialWave',
                builder: (context) => const MdInitialWave(),
              ),
              Story(
                name: 'Wave/BlurredCircle',
                builder: (context) => BlurredCircleStory(knobs: context.knobs),
              ),
              Story(
                name: 'Wave/GradientBackground',
                builder: (context) =>
                    GradientBackgroundStory(knobs: context.knobs),
              ),
              Story(
                name: 'Wave/GradientScaffoldWrapper',
                builder: (context) =>
                    GradientScaffoldWrapperStory(knobs: context.knobs),
              ),
              Story(
                name: 'Wave/GradientScaffoldWrapperAnimated',
                builder: (context) =>
                    const GradientScaffoldWrapperAnimatedStory(),
              ),
              Story(
                name: 'Wave/InitialScreen',
                builder: (context) => const InitialScreenStory(),
              ),
              Story(
                name: 'Wave/WaveDivider',
                builder: (context) => WaveDividerStory(knobs: context.knobs),
              ),
              Story(
                name: 'Wave/WaveChatBubble',
                builder: (context) => WaveChatBubbleStory(knobs: context.knobs),
              ),
              Story(
                name: 'Wave/WaveMicButton',
                builder: (context) => WaveMicButtonStory(knobs: context.knobs),
              ),
              Story(
                name: 'Wave/WaveStatus',
                builder: (context) => WaveStatusStory(knobs: context.knobs),
              ),
            ]..sort((a, b) => a.name.compareTo(b.name)),
          ),
        ),
      ),
    );
  }
}
