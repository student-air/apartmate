import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/core/widgets/app_skeletons.dart';
import 'package:apartmate/data/models/complaint_model.dart';
import 'package:apartmate/presentation/complaints/controllers/complaints_controller.dart';

class ComplaintsView extends GetView<ComplaintsController> {
  const ComplaintsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        // title: Text('Complaints', style: AppTextStyles.h4.copyWith(color: Colors.white)),
        title: Row(
  children: [
    ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'assets/images/logo.png',
        width: 28,
        height: 24,
        fit: BoxFit.cover,
      ),
    ),
    const SizedBox(width: 4),
    Text('Complaints', style: AppTextStyles.h4.copyWith(color: Colors.white)),
  ],
),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Obx(() {
            final hasItems = controller.selectedTab.value == 0
                ? controller.complaints.isNotEmpty
                : controller.resolved.isNotEmpty;
            if (!hasItems) return const SizedBox.shrink();
            return TextButton(
              onPressed: controller.confirmClearAll,
              child: Text(
                'Clear All',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.accentGreen),
              ),
            );
          }),
        ],
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: AppColors.accentGreen,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: AppTextStyles.labelLarge,
          tabs: const [
            Tab(text: 'All Complaints'),
            Tab(text: 'Resolved'),
          ],
        ),
      ),
      body: SafeArea(
        child: AppResponsiveContainer(
          child: Obx(() {
            if (controller.isLoading.value &&
                controller.complaints.isEmpty &&
                controller.resolved.isEmpty) {
              return const AppSkeletonList(itemBuilder: UpdateCardSkeleton.new);
            }
            return TabBarView(
              controller: controller.tabController,
              children: [
                _ComplaintsList(
                  items: controller.complaints,
                  emptyTitle: 'No complaints yet',
                  emptySubtitle: 'Resident complaints will show up here',
                  onDelete: controller.deleteComplaint,
                  onMarkSeen: (id) => controller.setStatus(id, ComplaintStatus.pending),
                  onMarkReviewed: (id) => controller.setStatus(id, ComplaintStatus.underReview),
                  onMarkResolved: controller.markResolved,
                  showActions: true,
                ),
                _ComplaintsList(
                  items: controller.resolved,
                  emptyTitle: 'No resolved complaints',
                  emptySubtitle: 'Resolved complaints will appear here',
                  onDelete: controller.deleteResolved,
                  onMarkSeen: null,
                  onMarkReviewed: null,
                  onMarkResolved: null,
                  showActions: false,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _ComplaintsList extends StatelessWidget {
  final List<ComplaintModel> items;
  final String emptyTitle;
  final String emptySubtitle;
  final Future<void> Function(String id) onDelete;
  final void Function(String id)? onMarkSeen;
  final void Function(String id)? onMarkReviewed;
  final void Function(String id)? onMarkResolved;
  final bool showActions;

  const _ComplaintsList({
    required this.items,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.onDelete,
    required this.onMarkSeen,
    required this.onMarkReviewed,
    required this.onMarkResolved,
    required this.showActions,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.report_outlined, size: 48, color: AppColors.textMuted),
              const SizedBox(height: 12),
              Text(emptyTitle, style: AppTextStyles.h4),
              const SizedBox(height: 6),
              Text(
                emptySubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: ValueKey(item.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColors.danger,
              borderRadius: BorderRadius.circular(AppDimens.radiusLg),
            ),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          onDismissed: (_) => onDelete(item.id),
          child: _ComplaintCard(
            complaint: item,
            showActions: showActions,
            onMarkSeen: onMarkSeen == null ? null : () => onMarkSeen!(item.id),
            onMarkReviewed: onMarkReviewed == null ? null : () => onMarkReviewed!(item.id),
            onMarkResolved: onMarkResolved == null ? null : () => onMarkResolved!(item.id),
            onDelete: () => onDelete(item.id),
          ),
        );
      },
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;
  final bool showActions;
  final VoidCallback? onMarkSeen;
  final VoidCallback? onMarkReviewed;
  final VoidCallback? onMarkResolved;
  final VoidCallback onDelete;

  const _ComplaintCard({
    required this.complaint,
    required this.showActions,
    required this.onMarkSeen,
    required this.onMarkReviewed,
    required this.onMarkResolved,
    required this.onDelete,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _statusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.pending:
        return AppColors.pending;
      case ComplaintStatus.underReview:
        return AppColors.warning;
      case ComplaintStatus.resolved:
        return AppColors.successGreen;
    }
  }

  String _statusLabel(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.pending:
        return 'Seen';
      case ComplaintStatus.underReview:
        return 'Reviewed';
      case ComplaintStatus.resolved:
        return 'Resolved';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(complaint.status);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  border: Border.all(color: AppColors.dangerBorder),
                ),
                child: Text(
                  complaint.category.isNotEmpty ? complaint.category : 'Complaint',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.danger),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  border: Border.all(color: statusColor.withOpacity(0.35)),
                ),
                child: Text(
                  _statusLabel(complaint.status),
                  style: AppTextStyles.labelSmall.copyWith(color: statusColor),
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(complaint.postedAt),
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
              if (showActions)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20, color: AppColors.textMuted),
                  onSelected: (value) {
                    switch (value) {
                      case 'seen':
                        onMarkSeen?.call();
                        break;
                      case 'reviewed':
                        onMarkReviewed?.call();
                        break;
                      case 'resolved':
                        onMarkResolved?.call();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'seen', child: Text('Mark as Seen')),
                    const PopupMenuItem(value: 'reviewed', child: Text('Mark as Reviewed')),
                    const PopupMenuItem(value: 'resolved', child: Text('Mark as Resolved')),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete', style: TextStyle(color: AppColors.danger)),
                    ),
                  ],
                )
              else
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20, color: AppColors.textMuted),
                  onSelected: (value) {
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete', style: TextStyle(color: AppColors.danger)),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(complaint.title, style: AppTextStyles.h4),
          const SizedBox(height: 4),
          Text(
            complaint.description,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}