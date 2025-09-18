import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/_core/precached_icons.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';

class WaveParticipant extends StatelessWidget {
  const WaveParticipant({
    super.key,
    this.size = 80,
    required this.label,
    required this.inCall,
    required this.muted,
    this.baseOutColor = MdColors.participantBaseOutColor,
    this.gradientOutColorFrom = MdColors.participantGradientOutStartColor,
    this.gradientOutColorTo = MdColors.participantGradientOutEndColor,
    this.baseInColor = MdColors.participantBaseInColor,
    this.gradientInColorFrom = MdColors.participantGradientInStartColor,
    this.gradientInColorTo = MdColors.participantGradientInEndColor,
    this.muteBadgeSize = 28,
    this.muteIconSize = 18,
    this.muteBadgeIconAsset = PrecachedIcons.participantMicIcon,
  });

  final double size;
  final String label;
  final Color baseOutColor;
  final Color gradientOutColorFrom;
  final Color gradientOutColorTo;
  final Color baseInColor;
  final Color gradientInColorFrom;
  final Color gradientInColorTo;
  final bool inCall;
  final bool muted;

  final double muteBadgeSize;
  final double muteIconSize;
  final String muteBadgeIconAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: inCall ? baseInColor : baseOutColor),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        inCall ? gradientInColorFrom : gradientOutColorFrom,
                        inCall ? gradientInColorTo : gradientOutColorTo,
                      ],
                    ),
                  ),
                ),
                Center(
                  child: WaveText(
                    label,
                    type: WaveTextType.subtitle,
                    weight: WaveTextWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (muted)
            Positioned(
              right: -3,
              bottom: -3,
              width: muteBadgeSize + 6,
              height: muteBadgeSize + 6,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: MdColors.participantIconBorderColor,
                    ),
                  ),
                  Center(
                    child: Container(
                      width: muteBadgeSize,
                      height: muteBadgeSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: MdColors.participantIconBackgroundColor,
                      ),
                    ),
                  ),
                  Center(
                    child: SvgPicture.asset(
                      muteBadgeIconAsset,
                      width: muteIconSize,
                      height: muteIconSize,
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
