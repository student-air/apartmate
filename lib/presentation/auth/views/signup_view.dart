import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_button.dart';
import 'package:apartmate/core/widgets/app_card.dart';
import 'package:apartmate/core/widgets/app_social_pill_button.dart';
import 'package:apartmate/core/widgets/app_text_field.dart';
import 'package:apartmate/presentation/auth/controllers/auth_controller.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

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
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                decoration: const BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppDimens.headerRadius),
                    bottomRight: Radius.circular(AppDimens.headerRadius),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/logo.png', width: 24, height: 24),
                    ),
                    Text(AppStrings.createAccount, style: AppTextStyles.h2.copyWith(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.signUpSubtitle,
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        label: AppStrings.fullName,
                        hint: AppStrings.fullNameHint,
                        controller: controller.fullNameCtrl,
                      ),
                      const SizedBox(height: AppDimens.space16),
                      AppTextField(
                        label: AppStrings.email,
                        hint: AppStrings.emailHint,
                        controller: controller.emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: AppDimens.space16),
                      AppTextField(
                        label: AppStrings.phoneNumber,
                        hint: AppStrings.phoneHint,
                        controller: controller.phoneCtrl,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: AppDimens.space16),
                      Obx(
                        () => AppTextField(
                          label: AppStrings.password,
                          hint: AppStrings.createPasswordHint,
                          controller: controller.signupPasswordCtrl,
                          obscureText: !controller.isSignupPasswordVisible.value,
                          suffixIcon: IconButton(
                            onPressed: controller.toggleSignupPasswordVisibility,
                            icon: Icon(
                              controller.isSignupPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimens.space16),
                      Obx(
                        () => AppTextField(
                          label: AppStrings.confirmPassword,
                          hint: AppStrings.confirmPasswordHint,
                          controller: controller.confirmPasswordCtrl,
                          obscureText: !controller.isConfirmPasswordVisible.value,
                          suffixIcon: IconButton(
                            onPressed: controller.toggleConfirmPasswordVisibility,
                            icon: Icon(
                              controller.isConfirmPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimens.space24),
                      Obx(
                        () => AppPrimaryButton(
                          label: AppStrings.register,
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: Colors.white,
                          isLoading: controller.isLoading.value,
                          onPressed: controller.signUp,
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
                      const SizedBox(height: AppDimens.space20),
                      Row(
                        children: [
                          Expanded(
                            child: AppSocialPillButton(
                              icon: Text(
                                'G',
                                style: AppTextStyles.labelLarge.copyWith(color: const Color(0xFF4285F4)),
                              ),
                              label: 'Google',
                              onPressed: controller.loginWithGoogle,
                            ),
                          ),
                          const SizedBox(width: AppDimens.space12),
                          Expanded(
                            child: AppSocialPillButton(
                              icon: const Icon(Icons.apple, size: 20, color: Colors.white),
                              label: 'Apple',
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              borderColor: Colors.black,
                              onPressed: controller.loginWithApple,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.space24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.alreadyHaveAccount, style: AppTextStyles.caption),
                  GestureDetector(
                    onTap: controller.goToLogin,
                    child: Text(AppStrings.login, style: AppTextStyles.labelLarge),
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