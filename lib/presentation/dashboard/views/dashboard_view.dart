import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_bottom_nav.dart';
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
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) return const AppLoading();
          final s = controller.stats.value;
          return SingleChildScrollView(
            child: AppResponsiveContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
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
                              Text('${DashboardController.greeting}, ${controller.ownerFirstName}',
                                  style: AppTextStyles.h3.copyWith(color: Colors.white)),
                              const SizedBox(height: 2),
                              Text(controller.societyName.value,
                                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.7))),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.goToProfile,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(color: AppColors.accentGreen.withValues(alpha: 0.15), shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: Text(controller.ownerInitials, style: AppTextStyles.labelLarge.copyWith(color: AppColors.accentGreenDark)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(child: _QuickAction(icon: Icons.edit_outlined, label: 'Edit Society', onTap: controller.goToEditSociety)),
                            const SizedBox(width: 12),
                            Expanded(child: _QuickAction(icon: Icons.people_outline, label: 'Add Staff', onTap: controller.goToAddStaff)),
                            const SizedBox(width: 12),
                            Expanded(child: _QuickAction(icon: Icons.notifications_outlined, label: 'Send Notice', accent: true, onTap: controller.goToSendNotice)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.9,
                          children: [
                            _StatCard(icon: Icons.location_city_outlined, label: 'Buildings', value: '${s?.buildings ?? 0}'),
                            _StatCard(icon: Icons.grid_view_outlined, label: 'Total Flats', value: '${s?.totalFlats ?? 0}'),
                            _StatCard(icon: Icons.people_outline, label: 'Mgmt Staff', value: '${s?.mgmtStaff ?? 0}'),
                            _StatCard(icon: Icons.notifications_active_outlined, label: 'Pending', value: '${s?.pendingRequests ?? 0}', accent: true),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('Tenant Requests', style: AppTextStyles.h4),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                                  child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: controller.goToRequests,
                              child: Text('View All', style: AppTextStyles.labelLarge.copyWith(color: AppColors.accentGreenDark)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _PlaceholderRequestCard(
                          initials: 'ZA',
                          name: 'Zain Ahmed',
                          subtitle: 'Bldg B · Flat 204',
                          title: 'Maintenance Request',
                          description: 'The kitchen sink has a severe water leak...',
                          time: '2 hours ago',
                        ),
                        const SizedBox(height: 12),
                        _PlaceholderRequestCard(
                          initials: 'SA',
                          name: 'Sara Ali',
                          subtitle: 'Bldg A · Flat 101',
                          title: 'Parking Issue',
                          description: 'Someone parked in my reserved spot #42...',
                          time: 'Yesterday',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: AppBottomNav(
        current: AppTab.home,
        onTabSelected: (tab) {
          switch (tab) {
            case AppTab.home:
              break;
            case AppTab.notices:
              controller.goToNotices();
              break;
            case AppTab.requests:
              controller.goToRequests();
              break;
            case AppTab.profile:
              controller.goToProfile();
              break;
          }
        },
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool accent;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accent ? AppColors.accentGreen.withValues(alpha: 0.15) : AppColors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: accent ? AppColors.accentGreenDark : AppColors.primaryDark),
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
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
  final bool accent;
  const _StatCard({required this.icon, required this.label, required this.value, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.h3),
              ],
            ),
          ),
          Icon(icon, size: 20, color: accent ? AppColors.pending : AppColors.primaryDark),
        ],
      ),
    );
  }
}

class _PlaceholderRequestCard extends StatelessWidget {
  final String initials;
  final String name;
  final String subtitle;
  final String title;
  final String description;
  final String time;

  const _PlaceholderRequestCard({
    required this.initials,
    required this.name,
    required this.subtitle,
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: AppColors.primaryDark.withValues(alpha: 0.05), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(initials, style: AppTextStyles.labelMedium),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.labelLarge),
                    Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.pendingBg, borderRadius: BorderRadius.circular(AppDimens.radiusSm)),
                child: Text('PENDING', style: AppTextStyles.labelSmall.copyWith(color: AppColors.pending)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: AppTextStyles.labelLarge),
          const SizedBox(height: 2),
          Text(description, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(time, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
              OutlinedButton(
                onPressed: null,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusFull)),
                ),
                child: const Text('View Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}