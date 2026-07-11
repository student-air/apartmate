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
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 4),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'A',
                    style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 48),
                  ),
                ),
                const SizedBox(height: 24),
                Text(AppStrings.appName, style: AppTextStyles.h1.copyWith(color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  AppStrings.appTagline,
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.8)),
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
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.5)),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}