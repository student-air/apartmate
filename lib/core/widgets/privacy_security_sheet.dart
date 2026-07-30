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

class PrivacySecuritySheet extends StatelessWidget {
  const PrivacySecuritySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radius2xl)),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Text('Privacy & Security', style: AppTextStyles.h3),
          const SizedBox(height: 20),

          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AppColors.surfaceMuted, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.fingerprint_rounded, size: 20, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Biometric Login', style: AppTextStyles.labelLarge),
                    Text(
                      'Use fingerprint or face unlock to sign in',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Obx(() => Switch(
                    value: controller.biometricLoginEnabled.value,
                    onChanged: controller.toggleBiometricLogin,
                    activeThumbColor: AppColors.accentGreen,
                  )),
            ],
          ),
          const Divider(height: 32, color: AppColors.borderLight),

          Row(
            children: [
              Expanded(child: Text('Change Password', style: AppTextStyles.labelLarge)),
              TextButton(
                onPressed: () => _confirmSendResetLink(context, controller),
                child: Text('Forgot Password?', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppTextField(
            label: 'Current Password',
            controller: controller.currentPasswordCtrl,
            obscureText: true,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'New Password',
            controller: controller.newPasswordCtrl,
            obscureText: true,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Confirm New Password',
            controller: controller.confirmPasswordCtrl,
            obscureText: true,
          ),
          const SizedBox(height: 20),
          Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isChangingPassword.value ? null : controller.changePassword,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusFull)),
                  ),
                  child: controller.isChangingPassword.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Update Password', style: TextStyle(color: AppColors.accentGreen)),
                ),
              )),
        ],
      ),
    );
  }

  void _confirmSendResetLink(BuildContext context, ProfileController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Reset password?'),
        content: const Text('We\'ll send a password reset link to your registered email address.'),
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