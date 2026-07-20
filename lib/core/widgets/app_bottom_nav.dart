import 'package:flutter/material.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';

enum AppTab { home, notices, requests, profile }

class AppBottomNav extends StatelessWidget {
  final AppTab current;
  final ValueChanged<AppTab> onTabSelected;

  const AppBottomNav({super.key, required this.current, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          _NavItem(icon: Icons.home_outlined, label: 'Home', active: current == AppTab.home, onTap: () => onTabSelected(AppTab.home)),
          _NavItem(icon: Icons.notifications_outlined, label: 'Notices', active: current == AppTab.notices, onTap: () => onTabSelected(AppTab.notices)),
          _NavItem(icon: Icons.list_alt_outlined, label: 'Requests', active: current == AppTab.requests, onTap: () => onTabSelected(AppTab.requests)),
          _NavItem(icon: Icons.person_outline, label: 'Profile', active: current == AppTab.profile, onTap: () => onTabSelected(AppTab.profile)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primaryDark : AppColors.textSecondary;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(label, style: (active ? AppTextStyles.labelMedium : AppTextStyles.bodySmall).copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}