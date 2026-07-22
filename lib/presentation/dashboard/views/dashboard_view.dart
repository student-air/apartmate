// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:apartmate/core/constants/app_colors.dart';
// import 'package:apartmate/core/constants/app_dimens.dart';
// import 'package:apartmate/core/constants/app_text_styles.dart';
// import 'package:apartmate/core/widgets/app_loading.dart';
// import 'package:apartmate/core/widgets/app_responsive_container.dart';
// import 'package:apartmate/presentation/dashboard/controllers/dashboard_controller.dart';

// class DashboardView extends GetView<DashboardController> {
//   const DashboardView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         bottom: false,
//         child: Obx(() {
//           if (controller.isLoading.value) return const AppLoading();
//           return SingleChildScrollView(
//             child: AppResponsiveContainer(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.fromLTRB(30, 28, 30, 60),
//                         decoration: const BoxDecoration(
//                           color: AppColors.primaryDark,
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(AppDimens.headerRadius),
//                             bottomRight: Radius.circular(AppDimens.headerRadius),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     '${DashboardController.greeting} \n${controller.ownerFirstName}',
//                                     style: AppTextStyles.h2.copyWith(color: Colors.white),
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     controller.societyName.value,
//                                     style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.7)),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: controller.goToProfile,
//                               child: Container(
//                                 width: 84,
//                                 height: 44,
//                                  decoration: const BoxDecoration(color: AppColors.surfaceMuted, shape: BoxShape.circle),
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   controller.ownerInitials,
//                                   style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryDark),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Positioned(
//                         left: 30,
//                         right: 30,
//                         bottom: -64,
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: _QuickAction(
//                                 icon: Icons.edit_rounded,
//                                 label: 'Edit Society',
//                                 color: AppColors.primaryDarkGradientEnd,
//                                 onTap: controller.goToEditSociety,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: _QuickAction(
//                                 icon: Icons.people_rounded,
//                                 label: 'Add Staff',
//                                 color: AppColors.primaryDarkGradientEnd,
//                                 onTap: controller.goToAddStaff,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: _QuickAction(
//                                 icon: Icons.campaign_rounded,
//                                 label: 'Updates',
//                                 color: AppColors.accentGreen,
//                                 onTap: controller.goToUpdates,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   // extra space so the overlapping cards don't collide with
//                   // whatever content comes next in the scroll view
//                   const SizedBox(height: 50),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// class _QuickAction extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   final VoidCallback onTap;
//   const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(AppDimens.radiusLg),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//         decoration: BoxDecoration(
//           color: AppColors.surface,
//           borderRadius: BorderRadius.circular(AppDimens.radiusLg),
//           boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 3))],
//         ),
//         child: Column(
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
//               child: Icon(icon, size: 18, color: color),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700, color: color),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        elevation: 30,
        onPressed: () {
          // TODO: hook up the action for this button once it's decided what it opens
        },
        child: const Icon(Icons.add, color: AppColors.accentGreen, size: 30),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surface,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: true,
                onTap: () {
                  // TODO: navigate to Home
                },
              ),
              _NavItem(
                icon: Icons.campaign_rounded,
                label: 'Updates',
                isActive: false,
                onTap: () {
                  // TODO: navigate to Notices
                },
              ),
              const SizedBox(width: 40), // space reserved for the notch/FAB
              _NavItem(
                icon: Icons.assignment_rounded,
                label: 'Requests',
                isActive: false,
                onTap: () {
                  // TODO: navigate to Requests
                },
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isActive: false,
                onTap: controller.goToProfile,
              ),
            ],
          ),
        ),
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
                      Container(
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
                                  Text(
                                    '${DashboardController.greeting} \n${controller.ownerFirstName}',
                                    style: AppTextStyles.h2.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    controller.societyNameText,
                                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.7)),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.goToProfile,
                              child: Container(
                                width: 84,
                                height: 44,
                                 decoration: const BoxDecoration(color: AppColors.surfaceMuted, shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: Text(
                                  controller.ownerInitials,
                                  style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryDark),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 30,
                        right: 30,
                        bottom: -64,
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
                  // extra space so the overlapping cards don't collide with
                  // whatever content comes next in the scroll view
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color color = isActive ? AppColors.primaryDarkGradientEnd : AppColors.textMuted;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
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
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 8),
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