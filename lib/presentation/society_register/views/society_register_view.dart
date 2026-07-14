import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_button.dart';
import 'package:apartmate/core/widgets/app_dropdown_field.dart';
import 'package:apartmate/core/widgets/app_text_field.dart';
import 'package:apartmate/presentation/society_register/controllers/society_register_controller.dart';

class SocietyRegisterView extends GetView<SocietyRegisterController> {
  const SocietyRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.registerSociety, style: AppTextStyles.h4.copyWith(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _OwnerPhotoPicker(controller: controller),
                  const SizedBox(height: AppDimens.space20),
                  AppTextField(label: AppStrings.societyName, controller: controller.societyNameCtrl),
                  const SizedBox(height: AppDimens.space16),
                  AppTextField(label: AppStrings.ownerName, controller: controller.ownerNameCtrl),
                  const SizedBox(height: AppDimens.space16),
                  AppTextField(label: AppStrings.address, controller: controller.addressCtrl, maxLines: 2),
                  const SizedBox(height: AppDimens.space16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: AppTextField(label: AppStrings.city, controller: controller.cityCtrl)),
                      const SizedBox(width: AppDimens.space16),
                      Expanded(
                        child: Obx(
                          () => AppDropdownField<String>(
                            label: AppStrings.country,
                            value: controller.selectedCountry.value,
                            items: controller.countries,
                            labelBuilder: (v) => v,
                            onChanged: controller.setCountry,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.space16),
                  AppTextField(
                    label: AppStrings.contactNumber,
                    controller: controller.contactCtrl,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: AppDimens.space16),
                  AppTextField(
                    label: AppStrings.descriptionOptional,
                    hint: AppStrings.descriptionHint,
                    controller: controller.descriptionCtrl,
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppDimens.space20),
                  Text('Upload Pictures', style: AppTextStyles.labelLarge),
                  const SizedBox(height: AppDimens.space8),
                  const _UploadPicturesBox(),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.borderLight)),
              ),
              child: Obx(
                () => AppPrimaryButton(
                  label: AppStrings.submitRegistration,
                  isLoading: controller.isSubmitting.value,
                  onPressed: controller.submit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerPhotoPicker extends StatelessWidget {
  final SocietyRegisterController controller;
  const _OwnerPhotoPicker({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final file = controller.ownerPhoto.value;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: controller.pickOwnerPhoto,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryDark.withValues(alpha: 0.3), width: 2),
                  ),
                  child: file != null
                      ? ClipOval(child: Image.file(file, fit: BoxFit.cover))
                      : Icon(Icons.camera_alt_outlined, size: 28, color: AppColors.primaryDark.withValues(alpha: 0.5)),
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: GestureDetector(
                  onTap: controller.pickOwnerPhoto,
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
              ),
            ],
          );
        }),
        const SizedBox(height: AppDimens.space8),
        Text('Add Owner Photo', style: AppTextStyles.labelLarge),
        const SizedBox(height: 2),
        Text('PNG or JPG, up to 5MB', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _UploadPicturesBox extends StatelessWidget {
  const _UploadPicturesBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 128,
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: AppColors.primaryDark.withValues(alpha: 0.3), width: 1.4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
            child: const Icon(Icons.camera_alt_outlined, size: 20, color: AppColors.primaryDark),
          ),
          const SizedBox(height: 8),
          Text('Tap to upload images', style: AppTextStyles.labelLarge),
          const SizedBox(height: 2),
          Text('PNG, JPG up to 5MB', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
