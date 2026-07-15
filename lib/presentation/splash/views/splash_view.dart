import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/presentation/splash/controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: controller.skip,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryDark, AppColors.primaryDarkGradientEnd],
            ),
          ),
          child: const SafeArea(child: _SplashContent()),
        ),
      ),
    );
  }
}

/// Owns two animation controllers:
/// - [_entranceController]: plays once — staggered fade + slide-up for the
///   logo, title, and tagline.
/// - [_glowController]: loops forever — a subtle "breathing" glow behind
///   the logo mark.
class _SplashContent extends StatefulWidget {
  const _SplashContent();

  @override
  State<_SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<_SplashContent> with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _glowController;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _logoSlide;

  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;

  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;

  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));

    _logoFade = CurvedAnimation(parent: _entranceController, curve: const Interval(0.0, 0.5, curve: Curves.easeOut));
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack)),
    );
    _logoSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );

    _titleFade = CurvedAnimation(parent: _entranceController, curve: const Interval(0.3, 0.75, curve: Curves.easeOut));
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.3, 0.75, curve: Curves.easeOut)),
    );

    _taglineFade = CurvedAnimation(parent: _entranceController, curve: const Interval(0.5, 1.0, curve: Curves.easeOut));
    _taglineSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.5, 1.0, curve: Curves.easeOut)),
    );

    _entranceController.forward();

    _glowController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    _glow = Tween<double>(begin: 0.15, end: 0.4).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 4),
        AnimatedBuilder(
          animation: Listenable.merge([_entranceController, _glowController]),
          builder: (context, child) {
            return SlideTransition(
              position: _logoSlide,
              child: FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentGreen.withValues(alpha: _glow.value),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '合',
                    style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 58),
),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        SlideTransition(
          position: _titleSlide,
          child: FadeTransition(
            opacity: _titleFade,
            child: Text(AppStrings.appName, style: AppTextStyles.h1.copyWith(color: Colors.white)),
          ),
        ),
        const SizedBox(height: 8),
        SlideTransition(
          position: _taglineSlide,
          child: FadeTransition(
            opacity: _taglineFade,
            child: Text(
              AppStrings.appTagline,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.8)),
            ),
          ),
        ),
        const Spacer(flex: 5),
        const SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.accentGreen),
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.appVersion,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.5)),
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}
