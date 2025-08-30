import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';

class WaveStatus extends StatelessWidget {
  const WaveStatus({
    super.key,
    required this.type,
  });

  final WaveStatusType type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 203,
        height: 21,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, 1.5),
              child: Icon(Icons.circle, color: type.color, size: 12),
            ),
            const SizedBox(width: 10),
            WaveText(
              type.label,
              type: WaveTextType.subtitle,
              weight: WaveTextWeight.bold,
              color: type.color,
            ),
          ],
        ));
  }
}

enum WaveStatusType {
  failed(color: MdColors.negativeColor, label: "Failed to connect"),
  success(color: MdColors.positiveColor, label: "Connected"),
  process(color: MdColors.brandColor, label: "Connecting"),
  done(color: MdColors.disabledColor, label: "Disconnected");

  const WaveStatusType({required this.color, required this.label});
  final Color color;
  final String label;
}
