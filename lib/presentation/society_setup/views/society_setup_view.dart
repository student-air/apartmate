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
      
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '合',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 260,
                    color: AppColors.primaryDark.withValues(alpha: 0.04),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
          child: Obx(() => AppMilestoneCelebration(trigger: controller.celebrationTrigger.value)),
        ),
          Column(
            children: [
              Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const AppLoading();
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    backgroundColor: AppColors.primaryDark,
                    titleSpacing: 0,
                    iconTheme: const IconThemeData(color: Colors.white),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/logo.png', height: 24),
                        const SizedBox(width: 8),
                        Text(AppStrings.societyBuildings, style: AppTextStyles.h4.copyWith(color: Colors.white)),
                      ],
                    ),
                    actions: [
                      IconButton(
                        onPressed: () => _showAddBuildingSheet(context),
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    sliver: SliverToBoxAdapter(
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
                                    justSaved: controller.justSavedBuildingId.value == b.id,
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
                    ),
                  ),
                ],
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
              child: Obx(
                () => AppPrimaryButton(
                  label: AppStrings.continueToStaffSetup,
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  onPressed: controller.hasConfiguredBuilding ? controller.continueToNextStep : null,
                ),
              ),
            ),
          ),
        ],
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
        //curve: Curves.easeOutBack,
        enterBottomSheetDuration: const Duration(milliseconds: 400),
    );
  }
  void _confirmDelete(BuildContext context, BuildingModel building) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete building?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('This will permanently remove "${building.name}" and its configuration.'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);
                controller.deleteBuilding(building.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Delete Building', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
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
            child: Icon(Icons.villa_rounded, size: 60, color: AppColors.primaryDark.withValues(alpha: 0.4)),
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

// class _BuildingTile extends StatelessWidget {
//   final BuildingModel building;
//   final VoidCallback onTap;
//   final VoidCallback onDelete;
//   const _BuildingTile({required this.building, required this.onTap, required this.onDelete});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(AppDimens.radius2xl),
//       child: AppCard(
//         child: Row(
//           children: [
//            AppPopIn(
//               child: Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryDark.withValues(alpha: 0.05),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: const Icon(Icons.villa_rounded, color: AppColors.primaryDark, size: 32),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(building.name, style: AppTextStyles.h4),
//                   const SizedBox(height: 2),
//                   Text(
//                     building.isConfigured ? AppStrings.detailsConfigured : AppStrings.tapToAddDetails,
//                     style: AppTextStyles.bodySmall.copyWith(
//                       color: building.isConfigured ? AppColors.successGreen : AppColors.textMuted,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             IconButton(
//               onPressed: onTap,
//               icon: const Icon(Icons.edit_sharp, size: 18, color: AppColors.textSecondary),
//               style: IconButton.styleFrom(backgroundColor: AppColors.surfaceMuted, shape: const CircleBorder()),
//             ),
//             const SizedBox(width: 8),
//             IconButton(
//               onPressed: onDelete,
//               icon: const Icon(Icons.delete_sharp, size: 18, color: AppColors.danger),
//               style: IconButton.styleFrom(backgroundColor: AppColors.dangerBg, shape: const CircleBorder()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
  
// }
class _BuildingTile extends StatefulWidget {
  final BuildingModel building;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool justSaved;

  const _BuildingTile({
    required this.building,
    required this.onTap,
    required this.onDelete,
    this.justSaved = false,
  });

  @override
  State<_BuildingTile> createState() => _BuildingTileState();
}

class _BuildingTileState extends State<_BuildingTile> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scale;
  late final Animation<double> _badgeOpacity;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.03), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.03, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
    _badgeOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
    ]).animate(_pulseController);

    if (widget.justSaved) _pulseController.forward();
  }

  @override
  void didUpdateWidget(covariant _BuildingTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.justSaved && !oldWidget.justSaved) {
      _pulseController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final building = widget.building;
    final details = building.details;
    final floors = details?.totalFloors ?? 0;
    final units = details?.totalApartments ?? 0;
    final isConfigured = building.isConfigured;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) => Transform.scale(
        scale: _scale.value,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            child!,
            Positioned(
              top: -8,
              right: -8,
              child: Opacity(
                opacity: _badgeOpacity.value,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(color: AppColors.successGreenDark, shape: BoxShape.circle),
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppDimens.radius2xl),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppPopIn(
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.villa_rounded, color: AppColors.primaryDark, size: 26),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(building.name, style: AppTextStyles.h4),
                        const SizedBox(height: 2),
                        Text(
                          isConfigured ? '$units units · $floors floors' : AppStrings.tapToAddDetails,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onTap,
                    icon: const Icon(Icons.edit_sharp, size: 16, color: AppColors.textSecondary),
                    style: IconButton.styleFrom(backgroundColor: AppColors.surfaceMuted, shape: const CircleBorder()),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: const Icon(Icons.delete_sharp, size: 16, color: AppColors.danger),
                    style: IconButton.styleFrom(backgroundColor: AppColors.dangerBg, shape: const CircleBorder()),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isConfigured ? AppColors.successGreen.withValues(alpha: 0.1) : AppColors.warningBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isConfigured ? Icons.check_circle : Icons.hourglass_bottom,
                      size: 12,
                      color: isConfigured ? AppColors.successGreenDark : AppColors.warning,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isConfigured ? AppStrings.buildingComplete : AppStrings.buildingInProgress,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isConfigured ? AppColors.successGreenDark : AppColors.warning,
                      ),
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