import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/presentation/profile/controllers/profile_controller.dart';

void showNotificationPreferencesSheet() {
  Get.bottomSheet(
    const NotificationPreferencesSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

class NotificationPreferencesSheet extends StatelessWidget {
  const NotificationPreferencesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radius2xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Text('Notification Preferences', style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Text(
            'Choose what you want to be notified about',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Obx(() => _ToggleRow(
                icon: Icons.campaign_rounded,
                title: 'Updates & Announcements',
                subtitle: 'New notices posted to residents',
                value: controller.notifyUpdates.value,
                onChanged: controller.setNotifyUpdates,
              )),
          const Divider(height: 24, color: AppColors.borderLight),
          Obx(() => _ToggleRow(
                icon: Icons.report_problem_rounded,
                title: 'Complaints',
                subtitle: 'New complaints from residents',
                value: controller.notifyComplaints.value,
                onChanged: controller.setNotifyComplaints,
              )),
          const Divider(height: 24, color: AppColors.borderLight),
          Obx(() => _ToggleRow(
                icon: Icons.assignment_rounded,
                title: 'Tenant Requests',
                subtitle: 'New registration requests',
                value: controller.notifyRequests.value,
                onChanged: controller.setNotifyRequests,
              )),
          const Divider(height: 24, color: AppColors.borderLight),
          Obx(() => _ToggleRow(
                icon: Icons.volume_up_rounded,
                title: 'Notification Sound',
                subtitle: 'Play a sound for new notifications',
                value: controller.notifySound.value,
                onChanged: controller.setNotifySound,
              )),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AppColors.primaryDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusFull)),
              ),
              child: const Text('Done', style: TextStyle(color: AppColors.accentGreen)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: AppColors.surfaceMuted, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Icon(icon, size: 19, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.labelLarge),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.accentGreen),
      ],
    );
  }
}