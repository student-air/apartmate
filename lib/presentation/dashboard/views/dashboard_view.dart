import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_bottom_nav.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/presentation/dashboard/controllers/dashboard_controller.dart';
import 'package:apartmate/core/widgets/send_update_sheet.dart';
import 'package:apartmate/core/widgets/app_skeletons.dart';
import 'package:lottie/lottie.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshRequestCounts();
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AppAddFab(
        onPressed: showSendUpdateSheet,
      ),
      bottomNavigationBar: AppBottomNav(
        activeTab: AppNavTab.home,
        onHome: () {},
        onUpdates: controller.goToUpdates,
        onRequests: controller.goToRequests,
        onProfile: controller.goToProfile,
      ),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const AppSkeletonList(itemBuilder: StaffTileSkeleton.new);
          }
          return RefreshIndicator(
            color: AppColors.primaryDark,
            onRefresh: controller.refreshAll,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: AppResponsiveContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Society name + logout
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentGreen.withValues(alpha: 0.7),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Obx(
                            () => Text(
                              controller.societyNameText.toUpperCase(),
                              style: AppTextStyles.overline,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: controller.confirmLogout,
                          icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.surfaceMuted,
                            shape: const CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Greeting + animation
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Obx(
                            () => RichText(
                              text: TextSpan(
                                style: AppTextStyles.h1.copyWith(
                                  color: AppColors.textPrimary,
                                  height: 1.1,
                                ),
                                children: [
                                  TextSpan(text: '${DashboardController.greeting},\n'),
                                  TextSpan(
                                    text: '${controller.ownerFirstName}.',
                                    style: const TextStyle(color: AppColors.accentGreen),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Lottie.asset(
                          DashboardController.greetingAnimationAsset,
                          width: 64,
                          height: 64,
                          fit: BoxFit.contain,
                          repeat: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Avatar + role
                    Row(
                      children: [
                        GestureDetector(
                          onTap: controller.goToProfile,
                          child: Obx(() {
                            final photoPath = controller.society.value?.ownerPhotoPath;
                            final hasPhoto = photoPath != null && photoPath.isNotEmpty;
                            return Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: AppColors.surfaceMuted,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: hasPhoto
                                  ? ClipOval(
                                      child: Image.file(
                                        File(photoPath),
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Text(
                                      controller.ownerInitials,
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                            );
                          }),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(child: Divider(color: AppColors.borderLight)),
                        const SizedBox(width: 12),
                        Text(
                          controller.roleDisplay,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Stat pills
                    SizedBox(
                      height: 112,
                      child: Obx(
                        () => ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _StatPill(
                              icon: Icons.villa_rounded,
                              value: '${controller.stats.value?.buildings ?? 0}',
                              label: 'Buildings',
                              filled: true,
                              onTap: controller.goToBuildings,
                            ),
                            const SizedBox(width: 10),
                            _StatPill(
                              icon: Icons.report_problem_rounded,
                              value: '${controller.complaintsCount.value}',
                              label: 'Complaints',
                              onTap: controller.goToComplaints,
                            ),
                            const SizedBox(width: 10),
                            _StatPill(
                              icon: Icons.people_rounded,
                              value: '${controller.residentsCount.value}',
                              label: 'Residents',
                              onTap: controller.goToResidents,
                            ),
                            const SizedBox(width: 10),
                            _StatPill(
                              icon: Icons.hourglass_bottom_rounded,
                              value: '${controller.pendingRequestsCount.value}',
                              label: 'Pending',
                              onTap: controller.goToRequests,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    Text(
                      'ACTIONS',
                      style: AppTextStyles.overline.copyWith(color: AppColors.primaryDark),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.borderLight, height: 1),
                    const SizedBox(height: 16),

                    _ActionRow(
                      icon: Icons.edit_rounded,
                      title: 'Edit Society',
                      subtitle: 'Manage society details',
                      onTap: controller.goToEditSociety,
                    ),
                    const SizedBox(height: 12),
                    _ActionRow(
                      icon: Icons.groups_rounded,
                      title: 'Add Staff',
                      subtitle: 'Manage society staff',
                      onTap: controller.goToAddStaff,
                    ),
                    const SizedBox(height: 12),
                    _ActionRow(
                      icon: Icons.campaign_rounded,
                      title: 'Post Update',
                      subtitle: 'Notify all residents',
                      filled: true,
                      onTap: showSendUpdateSheet,
                    ),

                    const SizedBox(height: 28),

                    // ── Occupancy overview (one card per building) ──
                    Text(
                      'OCCUPANCY OVERVIEW',
                      style: AppTextStyles.overline.copyWith(color: AppColors.primaryDark),
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      final list = controller.buildingOccupancy;
                      if (list.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppDimens.radiusXl),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Text(
                            'No buildings yet',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: [
                          for (var i = 0; i < list.length; i++) ...[
                            if (i > 0) const SizedBox(height: 12),
                            _OccupancyCard(item: list[i]),
                          ],
                        ],
                      );
                    }),

                    const SizedBox(height: 24),

                    // ── Recent activity ──
                    Text(
                      'RECENT ACTIVITY',
                      style: AppTextStyles.overline.copyWith(color: AppColors.primaryDark),
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      final items = controller.recentActivity;
                      if (items.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppDimens.radiusXl),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Text(
                            'No recent activity yet',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      }
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
                          border: Border.all(color: AppColors.borderLight),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            for (var i = 0; i < items.length; i++) ...[
                              if (i > 0)
                                const Divider(height: 1, color: AppColors.borderLight),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      items[i].icon,
                                      size: 20,
                                      color: items[i].iconColor,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            items[i].title,
                                            style: AppTextStyles.labelLarge,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            items[i].timeLabel,
                                            style: AppTextStyles.caption.copyWith(
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // ── Complaints last 7 days ──
                    Text(
                      'COMPLAINTS, LAST 7 DAYS',
                      style: AppTextStyles.overline.copyWith(color: AppColors.primaryDark),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => _ComplaintsChart(
                        counts: controller.weeklyComplaintCounts.toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Occupancy card (one per building)
// ─────────────────────────────────────────────
class _OccupancyCard extends StatelessWidget {
  final BuildingOccupancy item;
  const _OccupancyCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final pct = item.percent;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.buildingName,
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${item.occupiedFlats}/${item.totalFlats} flats',
                style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
              ),
              const Spacer(),
              Text(
                '${(pct * 100).round()}%',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.accentGreenDark),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 10,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Stat pill
// ─────────────────────────────────────────────
class _StatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool filled;
  final VoidCallback? onTap;

  const _StatPill({
    required this.icon,
    required this.value,
    required this.label,
    this.filled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = filled ? AppColors.accentGreen : AppColors.surface;
    final fg = filled ? Colors.white : AppColors.textPrimary;
    final iconColor = filled ? Colors.white : AppColors.textMuted;
    final labelColor =
        filled ? Colors.white.withValues(alpha: 0.85) : AppColors.textMuted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusXl),
      child: Container(
        width: 84,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
          border: filled ? null : Border.all(color: AppColors.borderLight),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: AppColors.accentGreen.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(height: 8),
            Text(value, style: AppTextStyles.h4.copyWith(color: fg)),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: labelColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Action row
// ─────────────────────────────────────────────
class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool filled;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.filled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = filled ? AppColors.accentGreen : AppColors.surface;
    final titleColor = filled ? Colors.white : AppColors.textPrimary;
    final subtitleColor =
        filled ? Colors.white.withValues(alpha: 0.8) : AppColors.textMuted;
    final iconBg =
        filled ? Colors.white.withValues(alpha: 0.2) : AppColors.surfaceMuted;
    final iconColor = filled ? Colors.white : AppColors.textSecondary;
    final chevronColor =
        filled ? Colors.white.withValues(alpha: 0.8) : AppColors.textMuted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusXl),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
          border: filled ? null : Border.all(color: AppColors.borderLight),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: AppColors.accentGreen.withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(icon, size: 19, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(color: titleColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(color: subtitleColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: chevronColor),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Complaints chart
// ─────────────────────────────────────────────
class _ComplaintsChart extends StatelessWidget {
  final List<int> counts;
  const _ComplaintsChart({required this.counts});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              painter: _LineChartPainter(counts: counts),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mon', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              Text('Sun', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<int> counts;
  _LineChartPainter({required this.counts});

  @override
  void paint(Canvas canvas, Size size) {
    if (counts.isEmpty) return;

    final maxVal = counts.reduce((a, b) => a > b ? a : b).clamp(1, 999);
    final paint = Paint()
      ..color = const Color(0xFFEA580C)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final stepX = size.width / (counts.length - 1).clamp(1, 999);

    for (var i = 0; i < counts.length; i++) {
      final x = i * stepX;
      final y = size.height -
          (counts[i] / maxVal) * size.height * 0.85 -
          size.height * 0.08;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);

    final dotPaint = Paint()..color = const Color(0xFFEA580C);
    for (var i = 0; i < counts.length; i++) {
      final x = i * stepX;
      final y = size.height -
          (counts[i] / maxVal) * size.height * 0.85 -
          size.height * 0.08;
      canvas.drawCircle(Offset(x, y), 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) => old.counts != counts;
}