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
                  const SizedBox(height: 16),
                  // AppPopIn(
                  //   delay: const Duration(milliseconds: 700),
                  //   child: Container(
                  //     width: double.infinity,
                  //     height: MediaQuery.of(context).size.height * 0.22,
                  //     padding: const EdgeInsets.all(20),
                  //     decoration: BoxDecoration(
                  //       gradient: const LinearGradient(
                  //         colors: [AppColors.accentGreenDark, AppColors.accentGreen],
                  //         begin: Alignment.topLeft,
                  //         end: Alignment.bottomRight,
                  //       ),
                  //       borderRadius: BorderRadius.circular(AppDimens.radius2xl),
                  //       boxShadow: [
                  //         BoxShadow(color: AppColors.accentGreen.withValues(alpha: 0.12), blurRadius: 18, offset: const Offset(0, 6)),
                  //       ],
                  //     ),
                  //     child: Column(
                  //       mainAxisSize: MainAxisSize.max,
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         AppPopIn(
                  //           delay: const Duration(milliseconds: 780),
                  //           child: Text(
                  //             'SOCIETY JOIN CODE',
                  //             textAlign: TextAlign.center,
                  //             style: AppTextStyles.overline.copyWith(color: Colors.white.withValues(alpha: 0.9), letterSpacing: 1.6),
                  //           ),
                  //         ),
                  //         const SizedBox(height: 10),
                  //         AppPopIn(
                  //           delay: const Duration(milliseconds: 860),
                  //           child: SelectableText(
                  //             controller.joinCode,
                  //             textAlign: TextAlign.center,
                  //             style: AppTextStyles.h1.copyWith(
                  //               color: Colors.white,
                  //               letterSpacing: 8,
                  //               fontFamily: 'monospace',
                  //             ),
                  //           ),
                  //         ),
                  //         const SizedBox(height: 6),
                  //         AppPopIn(
                  //           delay: const Duration(milliseconds: 920),
                  //           child: Text(
                  //             'Share this code !',
                  //             textAlign: TextAlign.center,
                  //             style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.85)),
                  //           ),
                  //         ),
                  //         const SizedBox(height: 6),
                  //         AppPopIn(
                  //           delay: const Duration(milliseconds: 980),
                  //           child: OutlinedButton.icon(
                  //             onPressed: () {
                  //               Clipboard.setData(ClipboardData(text: controller.joinCode));
                  //               AppSnackbar.info('Copied', 'Society code copied to clipboard');
                  //             },
                  //             icon: const Icon(Icons.copy, size: 16, color: Colors.white),
                  //             label: Text('Copy Code', style: AppTextStyles.labelMedium.copyWith(color: Colors.white)),
                  //             style: OutlinedButton.styleFrom(
                  //               side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
                  //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusFull)),
                  //               backgroundColor: Colors.black.withValues(alpha: 0.03),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  AppPopIn(
                    delay: const Duration(milliseconds: 700),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
                      decoration: BoxDecoration(
                        color: AppColors.textOnDark,
                        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SOCIETY JOIN CODE',
                                  style: AppTextStyles.overline.copyWith(color: AppColors.textPrimary, letterSpacing: 1),
                                ),
                                const SizedBox(height: 2),
                                SelectableText(
                                  controller.joinCode,
                                  style: AppTextStyles.h4.copyWith(
                                    fontFamily: 'monospace',
                                    letterSpacing: 2,
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
                            icon: const Icon(Icons.copy_rounded, size: 18),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.surfaceMuted,
                              shape: const CircleBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
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