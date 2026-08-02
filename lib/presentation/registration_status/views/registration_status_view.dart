import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_animations.dart';
import 'package:apartmate/core/widgets/app_button.dart';
import 'package:apartmate/core/widgets/app_card.dart';
import 'package:flutter/services.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/core/widgets/app_loading.dart';
import 'package:lottie/lottie.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/presentation/registration_status/controllers/registration_status_controller.dart';

class RegistrationStatusView extends GetView<RegistrationStatusController> {
  const RegistrationStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) return const AppLoading();
          final society = controller.society.value;

          return AppResponsiveContainer(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                children: [
                  const SizedBox(height: 2),
                  const AppAnimatedCheckmark(),
                  const SizedBox(height: 12),
                  AppFadeSlideIn(
                    delay: const Duration(milliseconds: 500),
                    child: Text(AppStrings.registrationSubmitted, style: AppTextStyles.h2, textAlign: TextAlign.center),
                  ),
                
                  const SizedBox(height: 4),
                  AppFadeSlideIn(
                    delay: const Duration(milliseconds: 650),
                    child: Text(
                      AppStrings.registrationSubmittedDesc,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 2),
                  AppPopIn(
                    delay: const Duration(milliseconds: 700),
                      child: SizedBox(
                      height: 140,
                      width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
        Positioned.fill(
                    child: Lottie.asset(
                      'assets/lottie/code.json',
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
        // No container / no background — just content on the animation
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Row(
                      children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                        Text(
                          'SOCIETY JOIN CODE',
                              style: AppTextStyles.overline.copyWith(
                              color: Colors.white,
                              letterSpacing: 1,
                                fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    SelectableText(
                      controller.joinCode,
                      style: AppTextStyles.h4.copyWith(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: controller.joinCode));
                  AppSnackbar.info('Copied', 'Society code copied to clipboard');
                },
                icon: const Icon(Icons.copy_rounded, size: 28, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),

AppFadeSlideIn(
  delay: const Duration(milliseconds: 850),
  child: Text(
    'Users enter this code to join your society',
    textAlign: TextAlign.center,
    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
  ),
),
                  const SizedBox(height: 22),
                  AppFadeSlideIn(
                    delay: const Duration(milliseconds: 900),
                    child: AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppStrings.status, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.accentGreen.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppPulseDot(color: AppColors.accentGreenDark),
                                        const SizedBox(width: 6),
                                        Text(
                                          AppStrings.pendingReview,
                                          style: AppTextStyles.labelMedium.copyWith(color: AppColors.accentGreenDark),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(AppStrings.date, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                                const SizedBox(height: 4),
                                Text(controller.formattedDate, style: AppTextStyles.labelLarge),
                              ],
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1)),
                        _InfoRow(
                          icon: Icons.home_outlined,
                          label: 'Society',
                          value: society?.name ?? '—',
                          delay: const Duration(milliseconds: 0),
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          icon: Icons.person_outline,
                          label: 'Owner',
                          value: society?.ownerName ?? '—',
                          delay: const Duration(milliseconds: 120),
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          icon: Icons.location_on_outlined,
                          label: 'Location',
                          value: society != null ? '${society.city} ${society.country}': '—',
                          delay: const Duration(milliseconds: 240),
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          icon: Icons.phone_outlined,
                          label: 'Contact',
                          value: society?.contactNumber ?? '—',
                          delay: const Duration(milliseconds: 360),
                        ),
                      ],
                    ),
                  ),
                ),
                  const SizedBox(height: 32),
                  AppPrimaryButton(
                    label: AppStrings.continueSetup,
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: AppColors.accentGreen,
                    onPressed: controller.continueSetup,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Duration delay;
  const _InfoRow({required this.icon, required this.label, required this.value, this.delay = Duration.zero});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppSpinInIcon(
          delay: delay,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.primaryDark.withValues(alpha: 0.05), shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: AppColors.primaryDark),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              Text(value, style: AppTextStyles.labelLarge),
            ],
          ),
        ),
      ],
    );
  }
}