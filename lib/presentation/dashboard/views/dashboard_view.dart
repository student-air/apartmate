import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_card.dart';
import 'package:apartmate/core/widgets/app_loading.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/presentation/dashboard/controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) return const AppLoading();
          final s = controller.stats.value;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: AppResponsiveContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(DashboardController.greeting,
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                            const SizedBox(height: 2),
                            Text(AppStrings.ownerName, style: AppTextStyles.h2),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.goToProfile,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(color: AppColors.primaryDark, borderRadius: BorderRadius.circular(16)),
                          alignment: Alignment.center,
                          child: Text('A', style: AppTextStyles.h4.copyWith(color: AppColors.accentGreen)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.7,
                    children: [
                      _StatCard(icon: Icons.location_city_outlined, label: 'Buildings', value: '${s?.buildings ?? 0}', onTap: controller.goToBuildings),
                      _StatCard(icon: Icons.home_outlined, label: 'Total Flats', value: '${s?.totalFlats ?? 0}'),
                      _StatCard(icon: Icons.people_outline, label: 'Mgmt Staff', value: '${s?.mgmtStaff ?? 0}', onTap: controller.goToStaff),
                      _StatCard(icon: Icons.hourglass_empty, label: 'Pending', value: '${s?.pendingRequests ?? 0}', accent: true),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(icon: Icons.location_city_outlined, label: 'Manage Buildings', onTap: controller.goToBuildings),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(icon: Icons.notifications_outlined, label: 'Notices', dark: true, onTap: controller.goToNotices),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool accent;
  final VoidCallback? onTap;
  const _StatCard({required this.icon, required this.label, required this.value, this.accent = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radius2xl),
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: accent ? AppColors.pending : AppColors.primaryDark),
            const SizedBox(height: 8),
            Text(value, style: AppTextStyles.h3),
            Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool dark;
  final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.label, required this.onTap, this.dark = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radius2xl),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark ? AppColors.primaryDark : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radius2xl),
          border: dark ? null : Border.all(color: AppColors.borderLight),
          boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: dark ? AppColors.accentGreen : AppColors.primaryDark),
            const SizedBox(height: 12),
            Text(label, style: AppTextStyles.labelLarge.copyWith(color: dark ? Colors.white : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}