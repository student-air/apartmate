import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_bottom_nav.dart';
import 'package:apartmate/core/widgets/app_loading.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/presentation/dashboard/controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AppAddFab(
        onPressed: () {
          // TODO: hook up the action for this button once it's decided what it opens
        },
      ),
      bottomNavigationBar: AppBottomNav(
        activeTab: AppNavTab.home,
        onHome: () {}, // already here
        onUpdates: controller.goToUpdates,
        onRequests: () {
          // TODO: navigate to Requests once that screen exists
        },
        onProfile: controller.goToProfile,
      ),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) return const AppLoading();
          return SingleChildScrollView(
            child: AppResponsiveContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        // The bottom padding here isn't visual spacing — it
                        // reserves room so the Stack's own layout size
                        // includes the quick-action cards below, which is
                        // what makes their lower half tappable. Flutter only
                        // forwards taps to positions within a Stack's own
                        // size, even with clipBehavior: Clip.none.
                        padding: const EdgeInsets.only(bottom: 74),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(30, 28, 30, 60),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryDark,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(AppDimens.headerRadius),
                              bottomRight: Radius.circular(AppDimens.headerRadius),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() =>Text(
                                      '${DashboardController.greeting} \n${controller.ownerFirstName}',
                                      style: AppTextStyles.h2.copyWith(color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Obx(() =>Text(
                                      controller.societyNameText,
                                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.7)),
                                    )),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: controller.goToProfile,
                                child: Container(
                                  width: 44,
                                  height: 44,
                                   decoration: const BoxDecoration(color: AppColors.surfaceMuted, shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Obx(() =>Text(
                                    controller.ownerInitials,
                                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryDark),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 30,
                        right: 30,
                        bottom: 0,
                        child: Row(
                          children: [
                            Expanded(
                              child: _QuickAction(
                                icon: Icons.edit_rounded,
                                label: 'Edit Society',
                                color: AppColors.primaryDarkGradientEnd,
                                onTap: controller.goToEditSociety,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _QuickAction(
                                icon: Icons.people_rounded,
                                label: 'Add Staff',
                                color: AppColors.primaryDarkGradientEnd,
                                onTap: controller.goToAddStaff,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _QuickAction(
                                icon: Icons.campaign_rounded,
                                label: 'Updates',
                                color: AppColors.accentGreen,
                                onTap: controller.goToUpdates,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.6,
                      children: [
                        _StatCard(
                          icon: Icons.villa_rounded,
                          label: 'Buildings',
                          value: '${controller.stats.value?.buildings ?? 0}',
                          color: AppColors.primaryDarkGradientEnd,
                          onTap: controller.goToBuildings,
                        ),
                        _StatCard(
                          icon: Icons.grid_view_rounded,
                          label: 'Total Flats',
                          value: '${controller.stats.value?.totalFlats ?? 0}',
                          color: const Color(0xFFFFC107),
                        ),
                        _StatCard(
                          icon: Icons.people_rounded,
                          label: 'Staff Info',
                          value: '${controller.stats.value?.mgmtStaff ?? 0}',
                          color: const Color(0xFF8B5CF6),
                          onTap: controller.goToAddStaff,
                        ),
                        _StatCard(
                          icon: Icons.hourglass_bottom_rounded,
                          label: 'Pending',
                          value: '${controller.stats.value?.pendingRequests ?? 0}',
                          color: AppColors.pending,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 28),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 3))],
        ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: AppTextStyles.h3),
                const SizedBox(height: 6),
                Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}