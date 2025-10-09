import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/widgets/gradient_scaffold_wrapper.dart';
import 'package:md_ui_kit/widgets/wave_divider.dart';
import 'package:md_ui_kit/widgets/wave_simple_button.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';
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
    final showScroll = context.knobs.boolean(
      label: 'Show Scroll',
      initial: false,
    );

    final showLogo = context.knobs.boolean(
      label: 'Show logo',
      initial: true,
    );

    final iosTopPadding = context.knobs.sliderInt(
      label: 'ios Top Padding',
      initial: 80,
      max: 200,
    );

    return GradientScaffoldWrapper(
      showLogo: showLogo,
      iosTopPadding: iosTopPadding.toDouble(),
      child: showScroll
          ? Stack(
              children: [
                // Align(
                //   alignment: Alignment.center,
                //   child:
                // ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.constrainWidth();

                    // если constraints.maxHeight бесконечен — возьмём высоту экрана (минус topPadding)
                    final rawMaxH = constraints.maxHeight;
                    final screenH = MediaQuery.of(context).size.height;
                    final h = rawMaxH.isFinite ? rawMaxH : (screenH - 68);

                    // безопасный Size для CustomPaint и SizedBox
                    final safeSize = Size(w, h);

                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Container(
                        height: h,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: MdColors.containerColor,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: WaveText(
                                  'One more step',
                                  type: WaveTextType.subtitle,
                                  weight: WaveTextWeight.bold,
                                  color: MdColors.brandColor,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const WaveText(
                                  'Create a code',
                                  type: WaveTextType.title,
                                  weight: WaveTextWeight.bold,
                                ),
                                const SizedBox(height: 10),
                                const WaveText(
                                  'If you want to initiate a connection',
                                  type: WaveTextType.caption,
                                  color: MdColors.disabledColor,
                                ),
                                const SizedBox(height: 24),
                                WaveSimpleButton(
                                  label: 'Create',
                                  onPressed: () {},
                                  type: WaveButtonType.main,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 11,
                                    horizontal: 56,
                                  ),
                                ),
                                const SizedBox(height: 80),
                                const WaveDivider(
                                    type: WaveDividerType.disabled,
                                    label: 'OR'),
                                const SizedBox(height: 80),
                                const WaveText(
                                  'Paste code from friend',
                                  type: WaveTextType.title,
                                  weight: WaveTextWeight.bold,
                                ),
                                const SizedBox(height: 10),
                                const WaveText(
                                  'If you want to connect to already created peer',
                                  type: WaveTextType.caption,
                                  color: MdColors.disabledColor,
                                ),
                                const SizedBox(height: 24),
                                WaveSimpleButton(
                                  label: 'Paste',
                                  onPressed: () {},
                                  type: WaveButtonType.main,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 11,
                                    horizontal: 56,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
