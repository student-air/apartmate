import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/presentation/profile/controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 56, 40, 80),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppDimens.headerRadius),
                      bottomRight: Radius.circular(AppDimens.headerRadius),
                    ),
                  ),
                  child: Center(
                    //asset: Image(image: image)
                    child: Text('My Profile', style: AppTextStyles.h1.copyWith(color: Colors.white)),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -52),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Avatar card
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppDimens.radius2xl),
                            boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))],
                          ),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Column(
                                children: [
                                  Obx(() {
                                    final path = controller.ownerPhotoPath.value;
                                    return Container(
                                      width: 88,
                                      height: 88,
                                      decoration: const BoxDecoration(color: AppColors.primaryDark, shape: BoxShape.circle),
                                      alignment: Alignment.center,
                                      child: path != null && path.isNotEmpty
                                          ? ClipOval(
                                              child: Image.file(
                                                File(path),
                                                width: 88,
                                                height: 88,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Text(controller.initials, style: AppTextStyles.h1.copyWith(color: AppColors.accentGreen)),
                                    );
                                  }),
                                  const SizedBox(height: 14),
                                  Text(controller.fullName, style: AppTextStyles.h3),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.accentGreen.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                                    ),
                                    child: Text(
                                      controller.role.toUpperCase(),
                                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.accentGreenDark),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 8,
                                child: IconButton(
                                  onPressed: controller.goToEditProfile,
                                  icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                                  style: IconButton.styleFrom(backgroundColor: AppColors.surfaceMuted, shape: const CircleBorder()),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Contact information
                        _SectionCard(
                          title: 'Contact Information',
                          children: [
                            _InfoRow(icon: Icons.phone_rounded, label: 'Phone Number', value: controller.phone),
                            const SizedBox(height: 14),
                            _InfoRow(icon: Icons.email_rounded, label: 'Email Address', value: controller.email),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Society assignment
                        Obx(
                          () => _SectionCard(
                            title: 'Society Assignment',
                            children: [
                              _InfoRow(
                                icon: Icons.location_on_rounded,
                                label: controller.societyName.value.isEmpty ? 'No society yet' : controller.societyName.value,
                                value: controller.societyAddress.value,
                                labelIsTitle: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Menu
                        _MenuTile(
                          icon: Icons.notifications_rounded,
                          iconColor: const Color(0xFF3B82F6),
                          label: 'Notification Preferences',
                          onTap: () => controller.showComingSoon('Notification Preferences'),
                        ),
                        const SizedBox(height: 10),
                        _MenuTile(
                          icon: Icons.shield_rounded,
                          iconColor: AppColors.danger,
                          label: 'Privacy & Security',
                          onTap: () => controller.showComingSoon('Privacy & Security'),
                        ),
                        const SizedBox(height: 10),
                        _MenuTile(
                          icon: Icons.help_rounded,
                          iconColor: AppColors.accentGreenDark,
                          label: 'Help & Support',
                          onTap: () => controller.showComingSoon('Help & Support'),
                        ),
                        const SizedBox(height: 10),
                        _MenuTile(
                          icon: Icons.description_rounded,
                          iconColor: AppColors.textSecondary,
                          label: 'Terms of Service',
                          onTap: () => controller.showComingSoon('Terms of Service'),
                        ),
                        const SizedBox(height: 20),

                        // Log out
                        SizedBox(
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: controller.confirmLogout,
                            icon: const Icon(Icons.logout, size: 18, color: AppColors.danger),
                            label: Text('Log Out', style: AppTextStyles.labelLarge.copyWith(color: AppColors.danger)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.dangerBorder),
                              backgroundColor: AppColors.dangerBg,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusFull)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radius2xl),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: AppTextStyles.overline),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool labelIsTitle;
  const _InfoRow({required this.icon, required this.label, required this.value, this.labelIsTitle = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: AppColors.primaryDarkGradientEnd.withValues(alpha: 0.1), shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: AppColors.primaryDarkGradientEnd),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!labelIsTitle) Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              if (!labelIsTitle) const SizedBox(height: 2),
              Text(
                labelIsTitle ? label : (value.isEmpty ? '—' : value),
                style: AppTextStyles.labelLarge,
              ),
              if (labelIsTitle && value.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  const _MenuTile({required this.icon, required this.iconColor, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(icon, size: 17, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTextStyles.labelLarge)),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}