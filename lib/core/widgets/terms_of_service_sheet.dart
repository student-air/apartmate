import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';

void showTermsOfServiceSheet() {
  Get.bottomSheet(
    const TermsOfServiceSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

class TermsOfServiceSheet extends StatelessWidget {
  const TermsOfServiceSheet({super.key});

  static const _sections = [
    (
      'Account Responsibility',
      'You are responsible for maintaining the confidentiality of your account credentials and for all activity that occurs under your account.',
    ),
    (
      'Tenant Data',
      'Information submitted by tenants — including personal, contact, and financial details — must be handled responsibly and used only for society management purposes.',
    ),
    (
      'Acceptable Use',
      'This app may not be used to post false information, harass residents or staff, or engage in any activity that violates applicable law.',
    ),
    (
      'Service Availability',
      'While we aim for reliable service, ApartMate is provided "as is" without guarantee of uninterrupted availability.',
    ),
    (
      'Changes to Terms',
      'These terms may be updated periodically. Continued use of the app after changes constitutes acceptance of the revised terms.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radius2xl)),
          ),
          child: Column(
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
              Text('Terms of Service', style: AppTextStyles.h3),
              const SizedBox(height: 4),
              Text(
                'Last updated: July 2026',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: _sections.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final (title, body) = _sections[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTextStyles.labelLarge),
                        const SizedBox(height: 4),
                        Text(body, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}