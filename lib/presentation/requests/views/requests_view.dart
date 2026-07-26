import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_bottom_nav.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/data/models/request_model.dart';
import 'package:apartmate/presentation/requests/controllers/requests_controller.dart';
import 'package:apartmate/core/widgets/send_update_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:apartmate/core/widgets/app_skeletons.dart';

class RequestsView extends GetView<RequestsController> {
  const RequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: -10,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', height: 32, fit: BoxFit.cover),
            const SizedBox(width: 2),
            Text('Requests', style: AppTextStyles.h3.copyWith(color: Colors.white)),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AppAddFab(
        onPressed: showSendUpdateSheet,
      ),
      bottomNavigationBar: AppBottomNav(
        activeTab: AppNavTab.requests,
        onHome: () => Get.offNamed(AppRoutes.dashboard),
        onUpdates: () => Get.offNamed(AppRoutes.updates),
        onRequests: () {}, // already here
        onProfile: () => Get.toNamed(AppRoutes.profile),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.requests.isEmpty) {
            return const AppSkeletonList(itemBuilder: UpdateCardSkeleton.new);
          }
          if (controller.requests.isEmpty) {
            return _EmptyState(onRefresh: controller.refresh);
          }
          return RefreshIndicator(
            color: AppColors.primaryDark,
            onRefresh: controller.refresh,
            child: AppResponsiveContainer(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                itemCount: controller.requests.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final request = controller.requests[index];
                  return _RequestCard(request: request);
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final RequestModel request;
  const _RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RequestsController>();
    return Obx(() {
      final isExpanded = controller.expandedRequestId.value == request.id;
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
            // Header: avatar, name, CNIC, pending badge
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
                    request.initials,
                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryDark, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.tenantName, style: AppTextStyles.h4),
                      const SizedBox(height: 2),
                      Text(
                        'CNIC: ${request.cnic}',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warningBg,
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    border: Border.all(color: AppColors.warningBorder),
                  ),
                  child: Text('PENDING', style: AppTextStyles.labelSmall.copyWith(color: AppColors.warning)),
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
                    '${request.buildingName} · Floor ${request.floor} · ${request.flatNumber}',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _CallablePhonePill(phone: request.phone),

            if (isExpanded) ...[
              const SizedBox(height: 16),
              _SectionBlock(
                title: 'Requested Flat',
                rows: [
                  _FieldPair(
                    left: (icon: Icons.villa_rounded, label: 'Building', value: request.buildingName),
                    right: (icon: Icons.stairs_rounded, label: 'Floor', value: '${request.floor}${_ordinalSuffix(request.floor)} Floor'),
                  ),
                  _FieldPair(
                    left: (icon: Icons.door_front_door_rounded, label: 'Flat Number', value: request.flatNumber),
                    right: (icon: Icons.king_bed_rounded, label: 'Flat Type', value: request.flatType),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SectionBlock(
                title: 'Tenancy Details',
                rows: [
                  _FieldPair(
                    left: (icon: Icons.event_rounded, label: 'Move-in Date', value: DateFormat('MMM d, yyyy').format(request.allotmentDate)),
                    right: (icon: Icons.calendar_month_rounded, label: 'Lease Duration', value: '${request.leaseDurationMonths} Months'),
                  ),
                  _FieldPair(
                    left: (icon: Icons.groups_rounded, label: 'Occupants', value: '${request.residentsCount} Members'),
                    right: (icon: Icons.payments_rounded, label: 'Monthly Rent', value: 'PKR ${request.rent.toStringAsFixed(0)}'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SectionBlock(
                title: 'Applicant Information',
                rows: [],
                infoLines: [
                  ('Profession', request.profession),
                  ('Employer / Company', request.employerCompany),
                  ('Previous Address', request.previousAddress),
                  ('Emergency Contact', request.emergencyContact),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.ignore(request),
                      icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.danger),
                      label: Text('Decline', style: AppTextStyles.labelLarge.copyWith(color: AppColors.danger)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        side: const BorderSide(color: AppColors.dangerBorder),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusFull)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => controller.accept(request),
                      icon: const Icon(Icons.check_rounded, size: 18, color: Colors.white),
                      label: Text('Accept', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: AppColors.successGreenDark,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusFull)),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => controller.toggleExpanded(request.id),
                  icon: const Icon(Icons.expand_more_rounded, size: 18, color: AppColors.accentGreen),
                  label: Text('View Details', style: AppTextStyles.labelLarge.copyWith(color: AppColors.accentGreen)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                    backgroundColor: AppColors.primaryDark,
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

class _EmptyState extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryDark,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lottie animation
                  Lottie.asset(
                    'assets/lottie/requests.json',
                    width: 320,
                    height: 280,
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                  const SizedBox(height: 20),
                  Text('No requests', style: AppTextStyles.h4),
                  const SizedBox(height: 6),
                  Text(
                    'Requests from new residents\nwill show up here.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
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