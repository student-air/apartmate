import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/data/models/resident_model.dart';
import 'package:apartmate/presentation/residents/controllers/residents_controller.dart';
import 'package:flutter/foundation.dart'; // for debugPrint if needed
import 'package:apartmate/domain/repositories/i_resident_repository.dart';

class ResidentDetailView extends StatelessWidget {
  const ResidentDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final resident = Get.arguments as ResidentModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Resident Details',
          style: AppTextStyles.h4.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──
            Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          resident.initials,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primaryDark,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(resident.name, style: AppTextStyles.h4),
                            const SizedBox(height: 2),
                            Text(
                              'CNIC: ${resident.cnic}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${resident.buildingName} · Floor ${resident.floor} · ${resident.flatNumber}',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _CallablePhonePill(phone: resident.phone),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Requested Flat ──
            _SectionBlock(
              title: 'Requested Flat',
              rows: [
                _FieldPair(
                  left: (icon: Icons.villa_rounded, label: 'Building', value: resident.buildingName),
                  right: (
                    icon: Icons.stairs_rounded,
                    label: 'Floor',
                    value: '${resident.floor}${_ordinalSuffix(resident.floor)} Floor',
                  ),
                ),
                _FieldPair(
                  left: (icon: Icons.door_front_door_rounded, label: 'Flat Number', value: resident.flatNumber),
                  right: (icon: Icons.king_bed_rounded, label: 'Flat Type', value: resident.flatType),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Tenancy Details ──
            _SectionBlock(
              title: 'Tenancy Details',
              rows: [
                _FieldPair(
                  left: (
                    icon: Icons.event_rounded,
                    label: 'Move-in Date',
                    value: DateFormat('MMM d, yyyy').format(resident.allotmentDate),
                  ),
                  right: (
                    icon: Icons.calendar_month_rounded,
                    label: 'Lease Duration',
                    value: '${resident.leaseDurationMonths} Months',
                  ),
                ),
                _FieldPair(
                  left: (
                    icon: Icons.groups_rounded,
                    label: 'Occupants',
                    value: '${resident.residentsCount} Members',
                  ),
                  right: (
                    icon: Icons.payments_rounded,
                    label: 'Monthly Rent',
                    value: 'PKR ${resident.rent.toStringAsFixed(0)}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Applicant Information ──
            _SectionBlock(
              title: 'Applicant Information',
              rows: const [],
              infoLines: [
                ('Profession', resident.profession),
                ('Employer / Company', resident.employerCompany),
                ('Previous Address', resident.previousAddress),
                ('Emergency Contact', resident.emergencyContact),
                ('Email', resident.email),
              ],
            ),
            const SizedBox(height: 24),

// Delete resident
SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: () => _confirmDelete(context, resident),
    icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.danger),
    label: Text(
      'Delete Resident',
      style: AppTextStyles.labelLarge.copyWith(color: AppColors.danger),
    ),
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(50),
      side: const BorderSide(color: AppColors.dangerBorder),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
    ),
  ),
),
          ],
        ),
      ),
    );
  }

  String _ordinalSuffix(int n) {
    if (n % 100 >= 11 && n % 100 <= 13) return 'th';
    switch (n % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
  void _confirmDelete(BuildContext context, ResidentModel resident) {
  Get.dialog(
    AlertDialog(
      title: const Text('Delete resident?'),
      content: Text(
        'This will permanently remove ${resident.name} from your residents list.',
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
  Get.back(); // close dialog
  try {
    final repo = Get.find<IResidentRepository>();
    await repo.removeResident(resident.id);

    // Refresh list if residents screen is still alive
    if (Get.isRegistered<ResidentsController>()) {
      final c = Get.find<ResidentsController>();
      c.residents.removeWhere((r) => r.id == resident.id);
    }

    Get.back(); // leave details page
    AppSnackbar.success('Deleted', '${resident.name} has been removed');
  } catch (e, st) {
    debugPrint('DELETE RESIDENT ERROR: $e');
    debugPrint('$st');
    AppSnackbar.error('Failed', e.toString());
  }
},
          child: const Text(
            'Delete',
            style: TextStyle(color: AppColors.danger),
          ),
        ),
      ],
    ),
  );
}
}

// ── Re-used private widgets (same as Requests screen) ──

class _CallablePhonePill extends StatelessWidget {
  final String phone;
  const _CallablePhonePill({required this.phone});

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppSnackbar.error('Unable to open dialer', 'No phone app available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _call,
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.successGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.call_rounded, size: 14, color: AppColors.successGreenDark),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(phone, style: AppTextStyles.bodyMedium)),
            Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final String title;
  final List<_FieldPair> rows;
  final List<(String, String)>? infoLines;
  const _SectionBlock({required this.title, required this.rows, this.infoLines});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: AppTextStyles.overline),
          const SizedBox(height: 10),
          ...rows.map((r) => Padding(padding: const EdgeInsets.only(bottom: 12), child: r)),
          if (infoLines != null)
            ...infoLines!.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text(line.$1, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                    ),
                    Expanded(
                      child: Text(
                        line.$2,
                        textAlign: TextAlign.right,
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryDark),
                      ),
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

class _FieldPair extends StatelessWidget {
  final ({IconData icon, String label, String value}) left;
  final ({IconData icon, String label, String value}) right;
  const _FieldPair({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _FieldItem(icon: left.icon, label: left.label, value: left.value)),
        const SizedBox(width: 12),
        Expanded(child: _FieldItem(icon: right.icon, label: right.label, value: right.value)),
      ],
    );
  }
}

class _FieldItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _FieldItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryDark)),
      ],
    );
  }
}