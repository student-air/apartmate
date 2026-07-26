import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_bottom_nav.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/core/widgets/app_skeletons.dart';
import 'package:apartmate/core/widgets/send_update_sheet.dart';
import 'package:apartmate/data/models/resident_model.dart';
import 'package:apartmate/presentation/residents/controllers/residents_controller.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';

class ResidentsView extends GetView<ResidentsController> {
  const ResidentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AppAddFab(
        onPressed: showSendUpdateSheet,
      ),
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', height: 24),
            const SizedBox(width: 8),
            Text('Residents', style: AppTextStyles.h4.copyWith(color: Colors.white)),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        activeTab: AppNavTab.home,
        onHome: () => Get.offAllNamed(AppRoutes.dashboard),
        onUpdates: () => Get.toNamed(AppRoutes.updates),
        onRequests: () => Get.toNamed(AppRoutes.requests),
        onProfile: () => Get.toNamed(AppRoutes.profile),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const AppSkeletonList(itemBuilder: StaffTileSkeleton.new);
        }
        final grouped = controller.groupedByBuilding;
        if (grouped.isEmpty) return const _EmptyResidentsState();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: AppResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: grouped.entries.expand((entry) {
                return [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 4),
                    child: Text(entry.key, style: AppTextStyles.h4),
                  ),
                  ...entry.value.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ResidentTile(resident: r),
                    ),
                  ),
                  const SizedBox(height: 8),
                ];
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}

class _EmptyResidentsState extends StatelessWidget {
  const _EmptyResidentsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryDark.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppDimens.radiusXl),
              ),
              child: Icon(Icons.groups_rounded, size: 40, color: AppColors.primaryDark.withValues(alpha: 0.4)),
            ),
            const SizedBox(height: 16),
            Text('No residents yet', style: AppTextStyles.h4),
            const SizedBox(height: 4),
            Text(
              'Accepted tenant requests will appear here',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResidentTile extends StatelessWidget {
  final ResidentModel resident;
  const _ResidentTile({required this.resident});

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: resident.phone.replaceAll(' ', ''));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppSnackbar.error('Unable to open dialer', 'No phone app available');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResidentsController>();
    return Obx(() {
      final isExpanded = controller.expandedResidentId.value == resident.id;
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
                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryDark, fontSize: 16),
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
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => showSendUpdateSheet(
                    prefillBuildingName: resident.buildingName,
                    prefillFloor: resident.floor,
                    prefillFlatNumber: resident.flatNumber,
                  ),
                  icon: const Icon(Icons.campaign_rounded, size: 20, color: AppColors.textSecondary),
                  style: IconButton.styleFrom(backgroundColor: AppColors.surfaceMuted, shape: const CircleBorder()),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
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
                    Expanded(child: Text(resident.phone, style: AppTextStyles.bodyMedium)),
                    Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppDimens.radiusLg),
              ),
              child: Row(
                children: [
                  Icon(Icons.email_rounded, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(resident.email, style: AppTextStyles.bodyMedium)),
                ],
              ),
            ),
            if (isExpanded) ...[
              const SizedBox(height: 14),
              _SectionBlock(
                title: 'Flat Details',
                rows: [
                  _FieldPair(
                    left: (icon: Icons.villa_rounded, label: 'Building', value: resident.buildingName),
                    right: (icon: Icons.stairs_rounded, label: 'Floor', value: '${resident.floor}${_ordinalSuffix(resident.floor)} Floor'),
                  ),
                  _FieldPair(
                    left: (icon: Icons.door_front_door_rounded, label: 'Flat Number', value: resident.flatNumber),
                    right: (icon: Icons.king_bed_rounded, label: 'Flat Type', value: resident.flatType),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SectionBlock(
                title: 'Tenancy Details',
                rows: [
                  _FieldPair(
                    left: (icon: Icons.event_rounded, label: 'Move-in Date', value: DateFormat('MMM d, yyyy').format(resident.allotmentDate)),
                    right: (icon: Icons.calendar_month_rounded, label: 'Lease Duration', value: '${resident.leaseDurationMonths} Months'),
                  ),
                  _FieldPair(
                    left: (icon: Icons.groups_rounded, label: 'Occupants', value: '${resident.residentsCount} Members'),
                    right: (icon: Icons.payments_rounded, label: 'Monthly Rent', value: 'PKR ${resident.rent.toStringAsFixed(0)}'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SectionBlock(
                title: 'Applicant Information',
                rows: [],
                infoLines: [
                  ('Profession', resident.profession),
                  ('Employer / Company', resident.employerCompany),
                  ('Previous Address', resident.previousAddress),
                  ('Emergency Contact', resident.emergencyContact),
                ],
              ),
              const SizedBox(height: 14),
              Center(
                child: InkWell(
                  onTap: () => controller.toggleExpanded(resident.id),
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: AppColors.surfaceMuted, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Icon(Icons.expand_less_rounded, size: 22, color: AppColors.textSecondary),
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => controller.toggleExpanded(resident.id),
                  icon: Icon(Icons.expand_more_rounded, size: 18, color: AppColors.primaryDark),
                  label: Text('Details', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryDark)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(42),
                    side: BorderSide(color: AppColors.primaryDark.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusFull)),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  String _ordinalSuffix(int n) {
    if (n % 100 >= 11 && n % 100 <= 13) return 'th';
    switch (n % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
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
