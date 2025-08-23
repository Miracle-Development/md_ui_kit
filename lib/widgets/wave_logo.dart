import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WaveLogo extends StatelessWidget {
  const WaveLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('icons/logo/wave.svg');
  }
}
