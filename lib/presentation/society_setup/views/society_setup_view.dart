import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_button.dart';
import 'package:apartmate/core/widgets/app_card.dart';
import 'package:apartmate/core/widgets/app_loading.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/core/widgets/app_text_field.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/presentation/society_setup/controllers/society_setup_controller.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:apartmate/core/widgets/app_animations.dart';

class SocietySetupView extends GetView<SocietySetupController> {
  const SocietySetupView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', height: 28),
            const SizedBox(width: 8),
            Text(AppStrings.societyBuildings, style: AppTextStyles.h4.copyWith(color: Colors.white)),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const AppLoading();
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: AppResponsiveContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (controller.buildings.isEmpty)
                        _EmptyBuildingsState()
                      else
                        ...controller.buildings.map(
                          (b) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _BuildingTile(
                              building: b,
                              onTap: () => Get.toNamed(AppRoutes.buildingDetail, arguments: b),
                              onDelete: () => _confirmDelete(context, b),
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () => _showAddBuildingSheet(context),
                        icon: const Icon(Icons.add, size: 20, color: AppColors.primaryDark),
                        label: Text(AppStrings.addBuilding, style: AppTextStyles.labelLarge),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                          side: BorderSide(color: AppColors.primaryDark.withValues(alpha: 0.3), width: 1.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius2xl)),
                          backgroundColor: AppColors.surface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.borderLight)),
              ),
              child: AppPrimaryButton(
                label: AppStrings.continueToStaffSetup,
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                onPressed: controller.continueToNextStep,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBuildingSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(3)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.addBuilding, style: AppTextStyles.h3),
                IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.close, size: 18),
                  style: IconButton.styleFrom(backgroundColor: AppColors.surfaceMuted, shape: const CircleBorder()),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: AppStrings.buildingName,
              hint: AppStrings.buildingNameHint,
              onChanged: controller.setNewBuildingName,
            ),
            const SizedBox(height: 24),
            Obx(
              () => AppPrimaryButton(
                label: AppStrings.saveBuilding,
                icon: Icons.check,
                onPressed: controller.newBuildingName.value.trim().isEmpty
                    ? null
                    : () async {
                        await controller.addBuilding();
                        Get.back();
                      },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
  void _confirmDelete(BuildContext context, BuildingModel building) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete building?'),
        content: Text('This will permanently remove "${building.name}" and its configuration.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              controller.deleteBuilding(building.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _EmptyBuildingsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppDimens.radiusXl),
            ),
            child: Icon(Icons.apartment_outlined, size: 40, color: AppColors.primaryDark.withValues(alpha: 0.4)),
          ),
          const SizedBox(height: 16),
          Text(AppStrings.noBuildingsAdded, style: AppTextStyles.h4),
          const SizedBox(height: 4),
          Text(AppStrings.noBuildingsHint, textAlign: TextAlign.center, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _BuildingTile extends StatelessWidget {
  final BuildingModel building;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  const _BuildingTile({required this.building, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radius2xl),
      child: AppCard(
        child: Row(
          children: [
           AppPopIn(
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.apartment_outlined, color: AppColors.primaryDark, size: 22),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(building.name, style: AppTextStyles.h4),
                  const SizedBox(height: 2),
                  Text(
                    building.isConfigured ? AppStrings.detailsConfigured : AppStrings.tapToAddDetails,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: building.isConfigured ? AppColors.successGreen : AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onTap,
              icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
              style: IconButton.styleFrom(backgroundColor: AppColors.surfaceMuted, shape: const CircleBorder()),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
              style: IconButton.styleFrom(backgroundColor: AppColors.dangerBg, shape: const CircleBorder()),
            ),
          ],
        ),
      ),
    );
  }
  
}