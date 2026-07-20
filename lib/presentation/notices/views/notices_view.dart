import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_bottom_nav.dart';
import 'package:apartmate/core/widgets/app_card.dart';
import 'package:apartmate/core/widgets/app_loading.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/data/models/notice_model.dart';
import 'package:apartmate/presentation/notices/controllers/notices_controller.dart';
import 'package:apartmate/routes/app_routes.dart';
class NoticesView extends GetView<NoticesController> {
  const NoticesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Notices & Complaints', style: AppTextStyles.h4.copyWith(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const AppLoading();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8,
                  children: [
                    _FilterChip(label: 'All', selected: controller.selectedFilter.value == null, onTap: () => controller.setFilter(null)),
                    _FilterChip(label: 'Notices', selected: controller.selectedFilter.value == NoticeType.notice, onTap: () => controller.setFilter(NoticeType.notice)),
                    _FilterChip(label: 'Complaints', selected: controller.selectedFilter.value == NoticeType.complaint, onTap: () => controller.setFilter(NoticeType.complaint)),
                    _FilterChip(label: 'Announcements', selected: controller.selectedFilter.value == NoticeType.announcement, onTap: () => controller.setFilter(NoticeType.announcement)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: controller.filteredNotices.isEmpty
                  ? const _EmptyNoticesState()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      child: AppResponsiveContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: controller.filteredNotices
                              .map((n) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _NoticeTile(notice: n),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
            ),
          ],
        );
      }),
      bottomNavigationBar: AppBottomNav(
        current: AppTab.notices,
        onTabSelected: (tab) {
          switch (tab) {
            case AppTab.home:
              Get.offNamed(AppRoutes.dashboard);
              break;
            case AppTab.notices:
              break;
            case AppTab.requests:
              Get.offNamed(AppRoutes.requests);
              break;
            case AppTab.profile:
              Get.offNamed(AppRoutes.profile);
              break;
          }
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryDark : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          border: Border.all(color: selected ? AppColors.primaryDark : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(color: selected ? Colors.white : AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _EmptyNoticesState extends StatelessWidget {
  const _EmptyNoticesState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_none, size: 48, color: AppColors.primaryDark.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('No Notices Yet', style: AppTextStyles.h4),
            const SizedBox(height: 4),
            Text('Notices you send will appear here.', style: AppTextStyles.caption, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _NoticeTile extends StatelessWidget {
  final NoticeModel notice;
  const _NoticeTile({required this.notice});

  ({Color bg, Color fg, String label}) get _typeInfo {
    switch (notice.type) {
      case NoticeType.notice:
        return (bg: AppColors.roleAdminBg, fg: AppColors.roleAdminText, label: 'Notice');
      case NoticeType.complaint:
        return (bg: AppColors.dangerBg, fg: AppColors.danger, label: 'Complaint');
      case NoticeType.announcement:
        return (bg: AppColors.rolePlumberBg, fg: AppColors.rolePlumberText, label: 'Announcement');
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = _typeInfo;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: info.bg, borderRadius: BorderRadius.circular(AppDimens.radiusSm)),
                child: Text(info.label, style: AppTextStyles.labelSmall.copyWith(color: info.fg)),
              ),
              const Spacer(),
              Text(_timeAgo(notice.postedAt), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(height: 8),
          Text(notice.title, style: AppTextStyles.labelLarge),
          const SizedBox(height: 4),
          Text(notice.description, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}