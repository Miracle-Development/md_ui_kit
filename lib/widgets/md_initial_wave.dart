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

  // Original artboard width used for proportional offsets (shadow was 528 in original)
  static const double _originalArtboardWidth = 528.0;

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
    // Use LayoutBuilder so we can make both SVGs use the same width (they'll scale
    // preserving aspect ratio). That keeps shadow and wave "stuck" together
    // when the window is resized on web.
    return LayoutBuilder(
      builder: (context, constraints) {
        // If parent gives unbounded width (rare in normal layouts), fall back to
        // MediaQuery or the original artboard width.
        final double availableWidth =
            (constraints.maxWidth.isFinite && constraints.maxWidth > 0)
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width;

        // Keep the same width for both SVGs so they scale together. If you used
        // pixel offsets (like top: 10) in the original design, scale that offset
        // proportionally to the new width so the relative placement remains.
        final double scaledTopOffset =
            10.0 * (availableWidth / _originalArtboardWidth);

        return SizedBox(
          width: availableWidth,
          // height can be left unconstrained so both SVGs determine their own
          // heights based on aspect ratio. The Stack will size to the tallest child.
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // shadow (second animation) — we position it using a scaled top offset
              Positioned(
                top: scaledTopOffset,
                left: 0,
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
                    'assets/icons/initial_wave/initial_wave_shadow.svg',
                    // give the shadow the same width as the wave so they stay aligned
                    width: availableWidth,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),

              // wave (first animation)
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
                  'assets/icons/initial_wave/initial_wave.svg',
                  // same width so both images scale together
                  width: availableWidth,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ],
          ),
        );
      },
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
