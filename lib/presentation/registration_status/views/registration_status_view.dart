import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_animations.dart';
import 'package:apartmate/core/widgets/app_button.dart';
import 'package:apartmate/core/widgets/app_card.dart';
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
                  const SizedBox(height: 16),
                  const AppAnimatedCheckmark(),
                  const SizedBox(height: 24),
                  Text(AppStrings.registrationSubmitted, style: AppTextStyles.h2, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.registrationSubmittedDesc,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  AppCard(
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
                                    child: Text(
                                      AppStrings.pendingReview,
                                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.accentGreenDark),
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
                          value: society != null ? '${society.city}, ${society.country}' : '—',
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
                  const SizedBox(height: 32),
                  const _StatusTimeline(),
                  const SizedBox(height: 32),
                  AppPrimaryButton(
                    label: AppStrings.continueSetup,
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
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

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TimelineStep(label: 'Submitted', state: _StepState.done),
        _TimelineConnector(active: true),
        _TimelineStep(label: 'Under Review', state: _StepState.active),
        _TimelineConnector(active: false),
        _TimelineStep(label: 'Approved', state: _StepState.pending),
      ],
    );
  }
}

enum _StepState { done, active, pending }

class _TimelineStep extends StatelessWidget {
  final String label;
  final _StepState state;
  const _TimelineStep({required this.label, required this.state});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Widget? child;
    Color textColor;
    switch (state) {
      case _StepState.done:
        bg = AppColors.successGreen;
        child = const Icon(Icons.check, size: 16, color: Colors.white);
        textColor = AppColors.successGreen;
        break;
      case _StepState.active:
        bg = AppColors.primaryDark;
        child = Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle));
        textColor = AppColors.primaryDark;
        break;
      case _StepState.pending:
        bg = Colors.white;
        child = null;
        textColor = AppColors.textSecondary;
        break;
    }
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: state == _StepState.pending ? Border.all(color: AppColors.border, width: 2) : null,
          ),
          alignment: Alignment.center,
          child: child,
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.labelMedium.copyWith(color: textColor)),
      ],
    );
  }
}

class _TimelineConnector extends StatelessWidget {
  final bool active;
  const _TimelineConnector({required this.active});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: active ? AppColors.successGreen : AppColors.border,
      ),
    );
  }
}