import 'package:flutter/material.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';

/// Which tab is currently highlighted in [AppBottomNav]. Use [none] for
/// secondary screens (e.g. Complaints) that are reached from elsewhere and
/// don't map to one of the 4 main tabs — no icon will be highlighted.
enum AppNavTab { home, updates, requests, profile, none }

/// The black FAB with the green plus icon, docked into the notch of
/// [AppBottomNav]. Shared so every screen gets the exact same look.
class AppAddFab extends StatelessWidget {
  final VoidCallback onPressed;
  const AppAddFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      elevation: 3,
      onPressed: onPressed,
      child: const Icon(Icons.add, color: AppColors.accentGreen, size: 30),
    );
  }
}

/// The bottom navigation bar used on every main screen (Dashboard, Updates,
/// Requests, Profile). Pass [activeTab] so the current screen highlights
/// its own icon, and the four onTap callbacks to wire up navigation.
class AppBottomNav extends StatelessWidget {
  final AppNavTab activeTab;
  final VoidCallback onHome;
  final VoidCallback onUpdates;
  final VoidCallback onRequests;
  final VoidCallback onProfile;

  const AppBottomNav({
    super.key,
    required this.activeTab,
    required this.onHome,
    required this.onUpdates,
    required this.onRequests,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
              isActive: activeTab == AppNavTab.home,
              onTap: onHome,
            ),
            _NavItem(
              icon: Icons.campaign_rounded,
              label: 'Updates',
              isActive: activeTab == AppNavTab.updates,
              onTap: onUpdates,
            ),
            const SizedBox(width: 40), // space reserved for the notch/FAB
            _NavItem(
              icon: Icons.assignment_rounded,
              label: 'Requests',
              isActive: activeTab == AppNavTab.requests,
              onTap: onRequests,
            ),
            _NavItem(
              icon: Icons.person_rounded,
              label: 'Profile',
              isActive: activeTab == AppNavTab.profile,
              onTap: onProfile,
            ),
          ],
        ),
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