import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_animations.dart';
import 'package:apartmate/core/widgets/app_text_field.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/domain/repositories/i_update_repository.dart';
import 'package:apartmate/presentation/send_update/controllers/send_update_controller.dart';

/// Opens the "Send Notice" compose form as a bottom sheet. Call this from
/// the '+' FAB wherever AppAddFab is used (Dashboard, Updates, Complaints).
Future<void> showSendUpdateSheet() {
  Get.put(
    SendUpdateController(Get.find<IUpdateRepository>(), Get.find<ISocietyRepository>()),
    tag: 'sendUpdate',
  );
  return Get.bottomSheet(
    const SendUpdateSheet(),
    isScrollControlled: true,
    enableDrag: false,
    backgroundColor: Colors.transparent,
  ).whenComplete(() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.delete<SendUpdateController>(tag: 'sendUpdate');
  });
}

class SendUpdateSheet extends StatelessWidget {
  const SendUpdateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SendUpdateController>(tag: 'sendUpdate');
    final maxHeight = MediaQuery.of(context).size.height * 0.88;

    void closeSheet() {
      FocusManager.instance.primaryFocus?.unfocus();
      Get.back();
    }

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimens.radius2xl),
            topRight: Radius.circular(AppDimens.radius2xl),
          ),
        ),
        child: Column(
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
                      Expanded(child: Text('Send Notice', style: AppTextStyles.h4)),
                      IconButton(
                        onPressed: closeSheet,
                        icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20, 4, 20, 24 + bottomInset),
                    child: AppShakeOnTrigger(
                      trigger: controller.shakeTrigger.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Notice Type', style: AppTextStyles.labelLarge),
                          const SizedBox(height: AppDimens.space6),
                          Obx(() => DropdownButtonFormField<String>(
                                initialValue: controller.selectedPreset.value,
                                items: SendUpdateController.presets.keys
                                    .map((preset) => DropdownMenuItem(value: preset, child: Text(preset)))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) controller.setPreset(value);
                                },
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                              )),
                          const SizedBox(height: AppDimens.space16),
                          Text('Send To', style: AppTextStyles.labelLarge),
                          const SizedBox(height: AppDimens.space6),
                          Obx(() => _SendToSelector(
                                options: SendUpdateController.sendToOptions,
                                selected: controller.sendTo.value,
                                onSelected: controller.setSendTo,
                              )),

                          // ── Cascading Building / Floor / Flat selectors ──
                          Obx(() {
                            if (controller.sendTo.value == 'All') return const SizedBox.shrink();

                            final showFloor =
                                controller.sendTo.value == 'Floor' || controller.sendTo.value == 'Flat';

                            Widget buildingField() {
                              if (controller.isLoadingBuildings.value) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: LinearProgressIndicator(),
                                );
                              }
                              if (controller.buildings.isEmpty) {
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceMuted,
                                    borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                                  ),
                                  child: Text(
                                    'No buildings !',
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                                  ),
                                );
                              }
                              return DropdownButtonFormField<BuildingModel>(
                                initialValue: controller.selectedBuilding.value,
                                hint: const Text('Tap to select'),
                                isExpanded: true,
                                items: controller.buildings
                                    .map((b) => DropdownMenuItem(value: b, child: Text(b.name)))
                                    .toList(),
                                onChanged: controller.setBuilding,
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                              );
                            }

                            Widget floorField() {
                              final hasBuilding = controller.selectedBuilding.value != null;
                              final floors = controller.availableFloors;
                              return DropdownButtonFormField<int>(
                                initialValue: controller.selectedFloor.value,
                                hint: const Text('Tap to select'),
                                isExpanded: true,
                                items: floors
                                    .map((f) => DropdownMenuItem(
                                          value: f,
                                          child: Text(SendUpdateController.floorLabel(f)),
                                        ))
                                    .toList(),
                                // Disabled until a building with floors is picked — same
                                // bordered look as the enabled state, just non-interactive.
                                onChanged: (!hasBuilding || floors.isEmpty) ? null : controller.setFloor,
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: AppDimens.space16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Text('Building', style: AppTextStyles.labelLarge),
                                          const SizedBox(height: AppDimens.space6),
                                          buildingField(),
                                        ],
                                      ),
                                    ),
                                    if (showFloor) ...[
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text('Floor', style: AppTextStyles.labelLarge),
                                            const SizedBox(height: AppDimens.space6),
                                            floorField(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            );
                          }),
                          Obx(() {
                            if (controller.sendTo.value != 'Flat') return const SizedBox.shrink();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: AppDimens.space16),
                                AppTextField(
                                  label: 'Flat',
                                  hint: AppStrings.flatNumberHint,
                                  controller: controller.flatNumberCtrl,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            );
                          }),
                          // ── end cascading selectors ──

                          const SizedBox(height: AppDimens.space16),
                          AppTextField(
                            label: 'Title',
                            hint: 'e.g. Water Supply Interruption',
                            controller: controller.titleCtrl,
                          ),
                          const SizedBox(height: AppDimens.space16),
                          AppTextField(
                            label: 'Description',
                            hint: 'Add details residents should know...',
                            controller: controller.descriptionCtrl,
                            maxLines: 4,
                          ),
                          const SizedBox(height: AppDimens.space16),
                          InkWell(
                            onTap: controller.addAttachment,
                            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceMuted,
                                borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.attach_file_rounded, size: 18, color: AppColors.textSecondary),
                                  const SizedBox(width: AppDimens.space8),
                                  Text(
                                    'Add Attachment (Optional)',
                                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimens.space24),
                          Obx(() => _SendButton(
                                isLoading: controller.isSending.value,
                                onPressed: controller.send,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      );
  }
}

class _SendToSelector extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;
  const _SendToSelector({required this.options, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = option == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  border: isSelected ? Border.all(color: AppColors.primaryDark) : null,
                  boxShadow: isSelected ? const [BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2))] : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  option,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isSelected ? AppColors.primaryDark : AppColors.textMuted,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  const _SendButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusFull)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentGreen),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send_rounded, size: 18, color: AppColors.accentGreen),
                  const SizedBox(width: AppDimens.space8),
                  Text('Send Notice', style: AppTextStyles.labelLarge.copyWith(color: AppColors.accentGreen)),
                ],
              ),
      ),
    );
  }
}