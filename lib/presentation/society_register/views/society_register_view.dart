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