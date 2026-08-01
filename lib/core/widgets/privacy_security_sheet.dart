import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_text_field.dart';
import 'package:apartmate/presentation/profile/controllers/profile_controller.dart';

void showPrivacySecuritySheet() {
  Get.bottomSheet(
    const PrivacySecuritySheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

class PrivacySecuritySheet extends StatefulWidget {
  const PrivacySecuritySheet({super.key});

  @override
  State<PrivacySecuritySheet> createState() => _PrivacySecuritySheetState();
}

class _PrivacySecuritySheetState extends State<PrivacySecuritySheet> {
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radius2xl)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text('Privacy & Security', style: AppTextStyles.h3),
              const SizedBox(height: 4),
              Text(
                'Manage your password and account security settings',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 8,
                  ),
                  children: [
                    // ── Biometric section ──
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryDark.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.fingerprint_rounded,
                                  size: 22,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Biometric Login', style: AppTextStyles.labelLarge),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Use fingerprint or face unlock',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Obx(
                                () => Switch.adaptive(
                                  value: controller.biometricLoginEnabled.value,
                                  activeColor: AppColors.accentGreen,
                                  onChanged: controller.toggleBiometricLogin,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Change password section ──
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.accentGreen.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.lock_rounded,
                                  size: 20,
                                  color: AppColors.successGreenDark,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text('Change Password', style: AppTextStyles.labelLarge),
                              ),
                              TextButton(
                                onPressed: () => _confirmSendResetLink(context, controller),
                                child: Text(
                                  'Forgot?',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.accentGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: 'Current Password',
                            controller: controller.currentPasswordCtrl,
                            obscureText: !_showCurrent,
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _showCurrent = !_showCurrent),
                              icon: Icon(
                                _showCurrent
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                size: 20,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'New Password',
                            controller: controller.newPasswordCtrl,
                            obscureText: !_showNew,
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _showNew = !_showNew),
                              icon: Icon(
                                _showNew
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                size: 20,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'Confirm New Password',
                            controller: controller.confirmPasswordCtrl,
                            obscureText: !_showConfirm,
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _showConfirm = !_showConfirm),
                              icon: Icon(
                                _showConfirm
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                size: 20,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Password must be at least 8 characters',
                            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 18),
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: controller.isChangingPassword.value
                                    ? null
                                    : controller.changePassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryDark,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                                  ),
                                ),
                                child: controller.isChangingPassword.value
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Update Password',
                                        style: AppTextStyles.labelLarge.copyWith(
                                          color: AppColors.accentGreen,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Security tip ──
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                        border: Border.all(
                          color: AppColors.primaryDark.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: AppColors.primaryDark.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Never share your password. Use a unique password for ApartMate and enable biometric login for faster, safer access.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmSendResetLink(BuildContext context, ProfileController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Reset password?'),
        content: const Text(
          'We\'ll send a password reset link to your registered email address.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.sendPasswordResetLink();
            },
            child: const Text('Send Link'),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }
}