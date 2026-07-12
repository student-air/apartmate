import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_button.dart';
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
                      child: Text('合', style: AppTextStyles.h4.copyWith(color: Colors.white)),
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
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.alreadyHaveAccount, style: AppTextStyles.caption),
                        GestureDetector(
                          onTap: controller.goToLogin,
                          child: Text(AppStrings.login, style: AppTextStyles.labelLarge),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}