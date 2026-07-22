// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:apartmate/core/constants/app_colors.dart';
// import 'package:apartmate/core/constants/app_dimens.dart';
// import 'package:apartmate/core/constants/app_text_styles.dart';
// import 'package:apartmate/core/widgets/app_loading.dart';
// import 'package:apartmate/core/widgets/app_responsive_container.dart';
// import 'package:apartmate/data/models/update_model.dart';
// import 'package:apartmate/presentation/updates/controllers/updates_controller.dart';

// class UpdatesView extends GetView<UpdatesController> {
//   const UpdatesView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         title: Text('Updates', style: AppTextStyles.h3),
//         centerTitle: false,
//       ),
//       body: SafeArea(
//         child: Obx(() {
//           if (controller.isLoading.value && controller.updates.isEmpty) {
//             return const AppLoading();
//           }
//           if (controller.updates.isEmpty) {
//             return _EmptyState(onRefresh: controller.refresh);
//           }
//           return RefreshIndicator(
//             color: AppColors.primaryDark,
//             onRefresh: controller.refresh,
//             child: AppResponsiveContainer(
//               child: ListView.separated(
//                 padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
//                 itemCount: controller.updates.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 12),
//                 itemBuilder: (context, index) {
//                   final update = controller.updates[index];
//                   return _UpdateCard(update: update);
//                 },
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// class _UpdateCard extends StatelessWidget {
//   final UpdateModel update;
//   const _UpdateCard({required this.update});

//   ({Color bg, Color text, Color border, String label}) get _typeStyle {
//     switch (update.type) {
//       case UpdateType.complaint:
//         return (bg: AppColors.dangerBg, text: AppColors.danger, border: AppColors.dangerBorder, label: 'Complaint');
//       case UpdateType.announcement:
//         return (bg: AppColors.roleAdminBg, text: AppColors.roleAdminText, border: AppColors.roleAdminBorder, label: 'Announcement');
//       case UpdateType.general:
//         return (bg: AppColors.warningBg, text: AppColors.warning, border: AppColors.warningBorder, label: 'Update');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final style = _typeStyle;
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(AppDimens.radiusLg),
//         boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 3))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: style.bg,
//                   borderRadius: BorderRadius.circular(AppDimens.radiusFull),
//                   border: Border.all(color: style.border),
//                 ),
//                 child: Text(
//                   style.label,
//                   style: AppTextStyles.labelSmall.copyWith(color: style.text),
//                 ),
//               ),
//               const Spacer(),
//               Text(
//                 _formatDate(update.postedAt),
//                 style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Text(update.title, style: AppTextStyles.h4),
//           const SizedBox(height: 4),
//           Text(
//             update.description,
//             style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
//     if (isToday) return DateFormat('h:mm a').format(date);
//     return DateFormat('MMM d').format(date);
//   }
// }

// class _EmptyState extends StatelessWidget {
//   final Future<void> Function() onRefresh;
//   const _EmptyState({required this.onRefresh});

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       color: AppColors.primaryDark,
//       onRefresh: onRefresh,
//       child: ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         children: [
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 0.6,
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 72,
//                     height: 72,
//                     decoration: const BoxDecoration(color: AppColors.surfaceMuted, shape: BoxShape.circle),
//                     alignment: Alignment.center,
//                     child: const Icon(Icons.campaign_rounded, size: 32, color: AppColors.textMuted),
//                   ),
//                   const SizedBox(height: 16),
//                   Text('No updates yet', style: AppTextStyles.h4),
//                   const SizedBox(height: 6),
//                   Text(
//                     'Updates and announcements will show up here.',
//                     textAlign: TextAlign.center,
//                     style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_bottom_nav.dart';
import 'package:apartmate/core/widgets/app_loading.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/data/models/update_model.dart';
import 'package:apartmate/presentation/updates/controllers/updates_controller.dart';
import 'package:apartmate/routes/app_routes.dart';

class UpdatesView extends GetView<UpdatesController> {
  const UpdatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Updates', style: AppTextStyles.h3),
        centerTitle: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AppAddFab(
        onPressed: () {
          // TODO: hook up the action for this button once it's decided what it opens
        },
      ),
      bottomNavigationBar: AppBottomNav(
        activeTab: AppNavTab.updates,
        onHome: () => Get.offNamed(AppRoutes.dashboard),
        onUpdates: () {}, // already here
        onRequests: () {
          // TODO: navigate to Requests once that screen exists
        },
        onProfile: () => Get.toNamed(AppRoutes.profile),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.updates.isEmpty) {
            return const AppLoading();
          }
          if (controller.updates.isEmpty) {
            return _EmptyState(onRefresh: controller.refresh);
          }
          return RefreshIndicator(
            color: AppColors.primaryDark,
            onRefresh: controller.refresh,
            child: AppResponsiveContainer(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                itemCount: controller.updates.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final update = controller.updates[index];
                  return _UpdateCard(update: update);
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _UpdateCard extends StatelessWidget {
  final UpdateModel update;
  const _UpdateCard({required this.update});

  ({Color bg, Color text, Color border, String label}) get _typeStyle {
    switch (update.type) {
      case UpdateType.complaint:
        return (bg: AppColors.dangerBg, text: AppColors.danger, border: AppColors.dangerBorder, label: 'Complaint');
      case UpdateType.announcement:
        return (bg: AppColors.roleAdminBg, text: AppColors.roleAdminText, border: AppColors.roleAdminBorder, label: 'Announcement');
      case UpdateType.general:
        return (bg: AppColors.warningBg, text: AppColors.warning, border: AppColors.warningBorder, label: 'Update');
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _typeStyle;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: style.bg,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  border: Border.all(color: style.border),
                ),
                child: Text(
                  style.label,
                  style: AppTextStyles.labelSmall.copyWith(color: style.text),
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(update.postedAt),
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(update.title, style: AppTextStyles.h4),
          const SizedBox(height: 4),
          Text(
            update.description,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    if (isToday) return DateFormat('h:mm a').format(date);
    return DateFormat('MMM d').format(date);
  }
}

class _EmptyState extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryDark,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(color: AppColors.surfaceMuted, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const Icon(Icons.campaign_rounded, size: 32, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),
                  Text('No updates yet', style: AppTextStyles.h4),
                  const SizedBox(height: 6),
                  Text(
                    'Updates and announcements will show up here.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}