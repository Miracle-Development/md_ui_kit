import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/md_text.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class MdTextStory extends StatelessWidget {
  const MdTextStory({super.key, required this.knobs});

  final KnobsBuilder knobs;

  @override
  Widget build(BuildContext context) {
    final textData = knobs.text(
      label: 'Содержание текста',
      initial: 'Пример виджета в сторибуке',
    );

    final Color color = knobs.options(
      label: 'Цвет текста',
      initial: Colors.black,
      options: const [
        Option(
          label: 'Черный',
          value: Colors.black,
        ),
        Option(
          label: 'Белый',
          value: Colors.white,
        ),
        Option(
          label: 'Красный',
          value: Colors.red,
        ),
      ],
    );

    // Ваш виджет тут
    return MdText(
      text: textData,
      color: color,
    );
  }
}
