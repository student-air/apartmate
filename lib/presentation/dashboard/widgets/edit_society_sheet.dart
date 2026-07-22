import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_animations.dart';
import 'package:apartmate/core/widgets/app_button.dart';
import 'package:apartmate/core/widgets/app_loading.dart';
import 'package:apartmate/core/widgets/app_text_field.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/presentation/dashboard/controllers/edit_society_controller.dart';

/// Opens the "Edit Society" form as a bottom sheet over whatever screen is
/// currently showing, instead of pushing a full new route. Call this from
/// DashboardController.goToEditSociety().
Future<void> showEditSocietySheet() {
  final controller = Get.put(
    EditSocietyController(Get.find<ISocietyRepository>()),
    tag: 'editSociety',
  );
  return Get.bottomSheet(
    const EditSocietySheet(),
    isScrollControlled: true,
    enableDrag: false,
    backgroundColor: Colors.transparent,
  ).whenComplete(() => Get.delete<EditSocietyController>(tag: 'editSociety'));
}

class EditSocietySheet extends StatelessWidget {
  const EditSocietySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditSocietyController>(tag: 'editSociety');
    final maxHeight = MediaQuery.of(context).size.height * 0.88;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppDimens.radius2xl),
              topRight: Radius.circular(AppDimens.radius2xl),
            ),
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const SizedBox(height: 240, child: AppLoading());
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
                  child: Row(
                    children: [
                      Expanded(child: Text('Edit Society', style: AppTextStyles.h4)),
                      IconButton(
                        onPressed: Get.back,
                        icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    child: AppShakeOnTrigger(
                      trigger: controller.shakeTrigger.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            label: AppStrings.societyName,
                            hint: AppStrings.societyNameHint,
                            controller: controller.societyNameCtrl,
                          ),
                          const SizedBox(height: AppDimens.space16),
                          AppTextField(
                            label: AppStrings.ownerName,
                            hint: AppStrings.ownerNameHint,
                            controller: controller.ownerNameCtrl,
                          ),
                          const SizedBox(height: AppDimens.space16),
                          AppTextField(
                            label: AppStrings.address,
                            hint: AppStrings.addressHint,
                            controller: controller.addressCtrl,
                            maxLines: 2,
                          ),
                          const SizedBox(height: AppDimens.space16),
                          Text('Country, State & City', style: AppTextStyles.labelLarge),
                          const SizedBox(height: AppDimens.space6),
                          SizedBox(
                            width: double.infinity,
                            child: SelectState(
                              showFlag: true,
                              showSearch: true,
                              countryHint: 'Select Country',
                              stateHint: 'Select State',
                              cityHint: 'Select City',
                              onCountryChanged: controller.setCountry,
                              onStateChanged: controller.setState,
                              onCityChanged: controller.setCity,
                            ),
                          ),
                          const SizedBox(height: AppDimens.space6),
                          Text(
                            'Currently set to: ${controller.currentLocationLabel}',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                          ),
                          const SizedBox(height: AppDimens.space16),
                          AppTextField(
                            label: AppStrings.contactNumber,
                            hint: AppStrings.contactNumberHint,
                            controller: controller.contactCtrl,
                            keyboardType: TextInputType.phone,
                          ),
                          Obx(() {
                            final error = controller.phoneError.value;
                            if (error == null) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: AppDimens.space8),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, size: 14, color: AppColors.danger),
                                  const SizedBox(width: AppDimens.space4),
                                  Expanded(
                                    child: Text(
                                      error,
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: AppDimens.space16),
                          AppTextField(
                            label: AppStrings.descriptionOptional,
                            hint: AppStrings.descriptionHint,
                            controller: controller.descriptionCtrl,
                            maxLines: 3,
                          ),
                          const SizedBox(height: AppDimens.space24),
                          Obx(() => AppPrimaryButton(
                                label: 'Save Changes',
                                isLoading: controller.isSaving.value,
                                onPressed: controller.save,
                              )
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}