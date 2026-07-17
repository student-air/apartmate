import 'package:flutter/material.dart';
import 'package:apartmate/core/constants/app_colors.dart';

/// Draws a success checkmark stroke-by-stroke, like it's being signed,
/// then loops (pause, reset, redraw) for as long as it stays on screen.
class AppAnimatedCheckmark extends StatefulWidget {
  const AppAnimatedCheckmark({super.key});

  @override
  State<AppAnimatedCheckmark> createState() => _AppAnimatedCheckmarkState();
}

class _AppAnimatedCheckmarkState extends State<AppAnimatedCheckmark> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    Future.delayed(const Duration(milliseconds: 150), _loop);
  }

  Future<void> _loop() async {
    while (mounted) {
      await _controller.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      builder: (context, circleScale, child) {
        return Transform.scale(
          scale: circleScale,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(color: AppColors.successGreen.withValues(alpha: 0.1), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.successGreen,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.successGreen.withValues(alpha: 0.3), blurRadius: 16)],
              ),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    size: const Size(64, 64),
                    painter: _CheckmarkPainter(progress: _controller.value),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  const _CheckmarkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.22, size.height * 0.52)
      ..lineTo(size.width * 0.42, size.height * 0.70)
      ..lineTo(size.width * 0.78, size.height * 0.32);

    final metrics = path.computeMetrics().first;
    final partialPath = metrics.extractPath(0, metrics.length * progress);

    canvas.drawPath(partialPath, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) => oldDelegate.progress != progress;
}

/// Wraps any child, spinning + fading + scaling it in after an optional
/// delay — used to stagger a row of icons (e.g. Society/Owner/Location/Contact).
class AppSpinInIcon extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const AppSpinInIcon({super.key, required this.child, this.delay = Duration.zero});

  @override
  State<AppSpinInIcon> createState() => _AppSpinInIconState();
}

class _AppSpinInIconState extends State<AppSpinInIcon> {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _started = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: _started ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
      builder: (context, t, child) {
        return Opacity(
          opacity: t,
          child: Transform.scale(
            scale: 0.4 + (0.6 * t),
            child: Transform.rotate(
              angle: (1 - t) * -3.14159,
              child: widget.child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}