import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/presentation/profile/controllers/profile_controller.dart';

void showHelpSupportSheet() {
  Get.bottomSheet(
    const HelpSupportSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

class HelpSupportSheet extends StatelessWidget {
  const HelpSupportSheet({super.key});

  Future<void> _emailSupport() async {
    final gmailAppUri = Uri.parse(
      'googlegmail://co?to=support@apartmate.app&subject=${Uri.encodeComponent('ApartMate Support Request')}',
    );
    final gmailWebUri = Uri.parse(
      'https://mail.google.com/mail/?view=cm&fs=1&to=support@apartmate.app&su=${Uri.encodeComponent('ApartMate Support Request')}',
    );

    if (await canLaunchUrl(gmailAppUri)) {
      await launchUrl(gmailAppUri);
    } else if (await canLaunchUrl(gmailWebUri)) {
      await launchUrl(gmailWebUri, mode: LaunchMode.externalApplication);
    } else {
      AppSnackbar.error('Unable to open Gmail', 'Please email support@apartmate.app directly');
    }
  }

  Future<void> _callSupport(String number) async {
    if (number.trim().isEmpty) {
      AppSnackbar.error('No number on file', 'Add a contact number in Edit Society first');
      return;
    }
    final uri = Uri(scheme: 'tel', path: number.replaceAll(' ', ''));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppSnackbar.error('Unable to open dialer', 'No phone app available');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
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
              Text('Help & Support', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 8,
                  ),
                  children: [
                    _ContactTile(
                      icon: Icons.email_rounded,
                      title: 'Email Support',
                      subtitle: 'support@apartmate.app',
                      onTap: _emailSupport,
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => _ContactTile(
                        icon: Icons.call_rounded,
                        title: 'Call Support',
                        subtitle: controller.societyContactNumber.value.isEmpty
                            ? 'No number on file'
                            : controller.societyContactNumber.value,
                        onTap: () => _callSupport(controller.societyContactNumber.value),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('FREQUENTLY ASKED QUESTIONS', style: AppTextStyles.overline),
                    const SizedBox(height: 12),
                    const _FaqTile(
                      question: 'How do I accept a tenant or owner request?',
                      answer:
                          'Go to Requests, open the Owners or Tenants tab, tap a request to expand details, then tap Accept. Accepted tenants are added as residents.',
                    ),
                    const _FaqTile(
                      question: 'How do I post an update to residents?',
                      answer:
                          'Tap the + button on the Dashboard, Updates, or Requests screen. Choose the update type, write the message, select the audience if needed, and send.',
                    ),
                    const _FaqTile(
                      question: 'Can I edit society details after registration?',
                      answer:
                          'Yes. From the Dashboard, tap Edit Society to update the society name, address, contact number, owner details, and related information anytime.',
                    ),
                    const _FaqTile(
                      question: 'How do I manage complaints?',
                      answer:
                          'Open Complaints from the Dashboard. You can mark items as Seen, Reviewed, or Resolved, and clear resolved complaints when needed.',
                    ),
                    const _FaqTile(
                      question: 'How do I add buildings, staff, owners, or committee members?',
                      answer:
                          'Use the Dashboard actions and related screens: Society Buildings for building setup, Add Staff for staff, and the Owners / Committee screens to view and manage those lists.',
                    ),
                    const _FaqTile(
                      question: 'Where can I see resident details?',
                      answer:
                          'Open Residents from the Dashboard. Tap any resident card to view full details such as flat info, contact details, and tenancy information. You can also call them from that screen.',
                    ),
                    const _FaqTile(
                      question: 'How do I change my password?',
                      answer:
                          'Go to Profile → Privacy & Security. Enter your current password and a new password, then tap Update Password. You can also use Forgot Password to receive a reset link.',
                    ),
                    const _FaqTile(
                      question: 'Who do I contact if something is not working?',
                      answer:
                          'Use Email Support in this Help & Support sheet, or Call Support if a society contact number is saved. For account or access issues, contact your society administrator.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 19, color: AppColors.successGreenDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelLarge),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(widget.question, style: AppTextStyles.labelMedium)),
                  Icon(
                    _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 8),
                Text(
                  widget.answer,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}