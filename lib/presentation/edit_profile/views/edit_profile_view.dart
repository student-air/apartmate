//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_button.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/core/widgets/app_text_field.dart';
import 'package:apartmate/presentation/edit_profile/controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Edit Profile', style: AppTextStyles.h4.copyWith(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: AppResponsiveContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Obx(() {
                  final file = controller.photo.value;
                  return GestureDetector(
                    onTap: controller.pickPhoto,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryDark.withValues(alpha: 0.3), width: 2),
                          ),
                          alignment: Alignment.center,
                          child: file != null
                              ? ClipOval(child: Image.file(file, width: 96, height: 96, fit: BoxFit.cover))
                              : Icon(Icons.camera_alt_outlined, size: 28, color: AppColors.primaryDark.withValues(alpha: 0.5)),
                        ),
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryDark,
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
                            ),
                            child: const Icon(Icons.edit, size: 13, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text('Change Photo', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ),
              const SizedBox(height: 28),
              AppTextField(label: 'Full Name', controller: controller.fullNameCtrl),
              const SizedBox(height: 16),
              AppTextField(label: 'Owner Name', controller: controller.ownerNameCtrl),
              const SizedBox(height: 16),
              AppTextField(label: 'Email Address', controller: controller.emailCtrl, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              AppTextField(label: 'Phone Number', controller: controller.phoneCtrl, keyboardType: TextInputType.phone),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusFull)),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      child: Text('Cancel', style: AppTextStyles.labelLarge),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => AppPrimaryButton(
                        label: 'Save',
                        isLoading: controller.isSaving.value,
                        onPressed: controller.save,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}