import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_bottom_nav.dart';
import 'package:apartmate/core/widgets/app_card.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/core/widgets/app_skeletons.dart';
import 'package:apartmate/data/models/resident_model.dart';
import 'package:apartmate/presentation/residents/controllers/residents_controller.dart';
import 'package:apartmate/routes/app_routes.dart';

class ResidentsView extends GetView<ResidentsController> {
  const ResidentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', height: 24),
            const SizedBox(width: 8),
            Text('Residents', style: AppTextStyles.h4.copyWith(color: Colors.white)),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        activeTab: AppNavTab.home,
        onHome: () => Get.offAllNamed(AppRoutes.dashboard),
        onUpdates: () => Get.toNamed(AppRoutes.updates),
        onRequests: () => Get.toNamed(AppRoutes.requests),
        onProfile: () => Get.toNamed(AppRoutes.profile),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const AppSkeletonList(itemBuilder: StaffTileSkeleton.new);
        }
        final grouped = controller.groupedByBuilding;
        if (grouped.isEmpty) return const _EmptyResidentsState();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: AppResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: grouped.entries.expand((entry) {
                return [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 4),
                    child: Text(entry.key, style: AppTextStyles.h4),
                  ),
                  ...entry.value.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ResidentTile(resident: r),
                    ),
                  ),
                  const SizedBox(height: 8),
                ];
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}

class _EmptyResidentsState extends StatelessWidget {
  const _EmptyResidentsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryDark.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppDimens.radiusXl),
              ),
              child: Icon(Icons.groups_rounded, size: 40, color: AppColors.primaryDark.withValues(alpha: 0.4)),
            ),
            const SizedBox(height: 16),
            Text('No residents yet', style: AppTextStyles.h4),
            const SizedBox(height: 4),
            Text(
              'Accepted tenant requests will appear here',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResidentTile extends StatelessWidget {
  final ResidentModel resident;
  const _ResidentTile({required this.resident});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              resident.initials,
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryDark, fontSize: 15),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resident.name, style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Text(
                  'Floor ${resident.floor} · Flat ${resident.flatNumber}',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  resident.phone,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Text(
            'Rs ${resident.rent.toStringAsFixed(0)}',
            style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}