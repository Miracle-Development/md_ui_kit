import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MdInitialWave extends StatelessWidget {
  const MdInitialWave({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AnimatedImageReveal();
  }
}

class _AnimatedImageReveal extends StatefulWidget {
  const _AnimatedImageReveal();

  @override
  State<_AnimatedImageReveal> createState() => _AnimatedImageRevealState();
}

class _AnimatedImageRevealState extends State<_AnimatedImageReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> firstAnim;
  late Animation<double> secondAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    firstAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
    );

    secondAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.7, curve: Curves.fastOutSlowIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // вторая анимация
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: AnimatedBuilder(
            animation: secondAnim,
            builder: (context, child) {
              return ClipPath(
                clipper: _DiagonalRevealClipper(
                  secondAnim.value,
                ),
                child: child,
              );
            },
            child: SvgPicture.asset(
              'icons/initial_wave/initial_wave_shadow.svg',
              height: 563.82,
              width: 528,
            ),
          ),
        ),

        // первая анимация
        AnimatedBuilder(
          animation: firstAnim,
          builder: (context, child) {
            return ClipRect(
              child: Align(
                alignment: Alignment.topLeft,
                widthFactor: firstAnim.value,
                child: child,
              ),
            );
          },
          child: SvgPicture.asset(
            'icons/initial_wave/initial_wave.svg',
            alignment: Alignment.centerLeft,
            height: 259,
          ),
        ),
      ],
    );
  }
}

class _DiagonalRevealClipper extends CustomClipper<Path> {
  _DiagonalRevealClipper(
    this.progress, {
    // ignore: unused_element
    this.begin = Alignment.topLeft,
    // ignore: unused_element
    this.end = Alignment.bottomRight,
  });

  final double progress;
  final Alignment begin;
  final Alignment end;

  @override
  Path getClip(Size size) {
    final path = Path();

    final dx = (end.x - begin.x) * size.width;
    final dy = (end.y - begin.y) * size.height;

    final cutX = begin.x * size.width + dx * progress;
    final cutY = begin.y * size.height + dy * progress;

    if (begin == Alignment.topLeft && end == Alignment.bottomRight) {
      path.moveTo(0, 0);
      path.lineTo(cutX, 0);
      path.lineTo(cutX, cutY);
      path.lineTo(0, cutY);
      path.close();
    }

    if (progress >= 1.0) {
      return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    }

    return path;
  }

  @override
  bool shouldReclip(covariant _DiagonalRevealClipper oldClipper) =>
      oldClipper.progress != progress ||
      oldClipper.begin != begin ||
      oldClipper.end != end;
}
