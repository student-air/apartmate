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
      '1. Acceptance of Terms',
      'By creating an account or using ApartMate, you agree to these Terms of Service. '
      'If you do not agree, do not use the app. These terms apply to Society Admins, '
      'Owners, Committee members, Staff, and any other authorized users of the platform.',
    ),
    (
      '2. About ApartMate',
      'ApartMate is a property and society management application that helps connect '
      'Super Admins, Society Admins, Owners, and Tenants through role-specific dashboards. '
      'It supports society registration, building setup, staff management, resident records, '
      'owner records, committee members, tenant/owner requests, complaints, and updates/announcements.',
    ),
    (
      '3. Eligibility & Accounts',
      'You must provide accurate registration information and keep your credentials secure. '
      'You are responsible for all activity under your account. Society Admins are responsible '
      'for managing access and data related to their society. Notify us promptly if you suspect '
      'unauthorized use of your account.',
    ),
    (
      '4. Society Registration & Approval',
      'Society registration may require review and approval. Submitting a registration does not '
      'guarantee acceptance. False, incomplete, or misleading society details may result in '
      'rejection or later suspension of the society account.',
    ),
    (
      '5. Roles & Responsibilities',
      'Different roles have different permissions (for example: managing buildings, staff, '
      'residents, owners, committee, requests, complaints, and updates). Users must only perform '
      'actions allowed for their role and must not attempt to access or alter data outside their authority.',
    ),
    (
      '6. Resident, Owner & Tenant Data',
      'Personal information collected through ApartMate — including names, CNIC, phone numbers, '
      'emails, addresses, flat details, lease information, and related records — must be used only '
      'for legitimate society management purposes. Society Admins and authorized users must handle '
      'this data carefully and must not share it outside the app without a lawful basis or consent.',
    ),
    (
      '7. Requests, Complaints & Updates',
      'Request submissions, complaint tracking, and society updates/announcements must be accurate '
      'and made in good faith. Users must not post false, defamatory, harassing, or unlawful content. '
      'Society Admins are responsible for reviewing and acting on requests and complaints in a fair '
      'and timely manner.',
    ),
    (
      '8. Acceptable Use',
      'You agree not to:\n'
      '• Use ApartMate for any illegal purpose\n'
      '• Harass, threaten, or discriminate against residents, owners, staff, or other users\n'
      '• Upload or distribute malware, spam, or harmful content\n'
      '• Attempt to hack, scrape, reverse-engineer, or disrupt the service\n'
      '• Impersonate another person or misrepresent your role or authority',
    ),
    (
      '9. Service Availability',
      'ApartMate is provided on an “as is” and “as available” basis. We aim for reliable service '
      'but do not guarantee uninterrupted, error-free, or always-available access. Features may '
      'change, and temporary outages or maintenance may occur without prior notice.',
    ),
    (
      '10. Intellectual Property',
      'ApartMate, including its name, logo, design, code, and content, is protected by applicable '
      'intellectual property laws. You may not copy, modify, distribute, or create derivative works '
      'from the app except as expressly allowed.',
    ),
    (
      '11. Limitation of Liability',
      'To the fullest extent permitted by law, ApartMate and its operators are not liable for '
      'indirect, incidental, special, or consequential damages arising from use of the app, '
      'including decisions made based on data stored in the platform (such as tenancy, payments, '
      'or complaint records). You use the service at your own risk.',
    ),
    (
      '12. Termination',
      'We may suspend or terminate access if you violate these terms, misuse the platform, or '
      'if required by law. You may stop using ApartMate at any time. Upon termination, your right '
      'to access the service ends, subject to any data retention obligations that apply.',
    ),
    (
      '13. Changes to These Terms',
      'We may update these Terms of Service from time to time. Continued use of ApartMate after '
      'changes take effect constitutes acceptance of the revised terms. Material changes may be '
      'communicated through the app or related channels when practical.',
    ),
    (
      '14. Contact',
      'For questions about these Terms of Service, contact your society administrator or use the '
      'Help & Support option available in the ApartMate profile menu.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text('Terms of Service', style: AppTextStyles.h3),
              const SizedBox(height: 4),
              Text(
                'Last updated: August 2026',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 8),
              Text(
                'These terms govern your use of ApartMate for society and property management.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: _sections.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    final (title, body) = _sections[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTextStyles.labelLarge),
                        const SizedBox(height: 6),
                        Text(
                          body,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
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