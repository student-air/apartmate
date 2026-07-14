import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_button.dart';
import 'package:apartmate/core/widgets/app_card.dart';
import 'package:apartmate/core/widgets/app_text_field.dart';
import 'package:apartmate/presentation/auth/controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
                decoration: const BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppDimens.headerRadius),
                    bottomRight: Radius.circular(AppDimens.headerRadius),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(AppStrings.welcomeBack, style: AppTextStyles.h2.copyWith(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.signInSubtitle,
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, -16, 20, 24),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        label: AppStrings.username,
                        hint: AppStrings.usernameHint,
                        controller: controller.usernameCtrl,
                      ),
                      const SizedBox(height: AppDimens.space20),
                      Obx(
                        () => AppTextField(
                          label: AppStrings.password,
                          hint: AppStrings.passwordHint,
                          controller: controller.passwordCtrl,
                          obscureText: !controller.isPasswordVisible.value,
                          suffixIcon: IconButton(
                            onPressed: controller.togglePasswordVisibility,
                            icon: Icon(
                              controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimens.space16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Get.snackbar('Coming soon', 'Password reset isn\'t available yet');
                          },
                          child: Text(AppStrings.forgotPassword, style: AppTextStyles.labelLarge),
                        ),
                      ),
                      const SizedBox(height: AppDimens.space16),
                      Obx(
                        () => AppPrimaryButton(
                          label: AppStrings.login,
                          isLoading: controller.isLoading.value,
                          onPressed: controller.login,
                        ),
                      ),
                      const SizedBox(height: AppDimens.space24),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(AppStrings.or, style: AppTextStyles.bodySmall),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: AppDimens.space24),
                      AppSecondaryButton(
                        label: AppStrings.continueWithGoogle,
                        leading: Text('G', style: AppTextStyles.labelLarge.copyWith(color: const Color(0xFF4285F4))),
                        onPressed: controller.loginWithGoogle,
                      ),
                      const SizedBox(height: AppDimens.space12),
                      AppSecondaryButton(
                        label: AppStrings.continueWithApple,
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        borderColor: Colors.black,
                        leading: const Icon(Icons.apple, color: Colors.white, size: 22),
                        onPressed: controller.loginWithApple,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.space24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.noAccount, style: AppTextStyles.caption),
                  GestureDetector(
                    onTap: controller.goToSignup,
                    child: Text(AppStrings.signUp, style: AppTextStyles.labelLarge),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.space24),
            ],
          ),
        ),
      ),
    );
  }
}
