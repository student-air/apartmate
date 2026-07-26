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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warningBg,
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    border: Border.all(color: AppColors.warningBorder),
                  ),
                  child: Text('Pending', style: AppTextStyles.labelSmall.copyWith(color: AppColors.warning)),
                ),
                const Spacer(),
                Text(
                  _formatDate(request.submittedAt),
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(request.tenantName, style: AppTextStyles.h4),
            const SizedBox(height: 4),
            Text(
              'Flat ${request.flatNumber} · Floor ${request.floor} · ${request.buildingName}',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            if (isExpanded) ...[
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 14),
              _DetailRow(label: 'Phone', value: request.phone),
              _DetailRow(label: 'Email', value: request.email),
              _DetailRow(label: 'Residents', value: '${request.residentsCount}'),
              _DetailRow(label: 'Allotment Date', value: DateFormat('MMM d, yyyy').format(request.allotmentDate)),
              _DetailRow(label: 'Rent', value: 'Rs ${request.rent.toStringAsFixed(0)}'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => controller.ignore(request),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        side: const BorderSide(color: AppColors.dangerBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                        ),
                      ),
                      child: Text('Ignore', style: AppTextStyles.labelLarge.copyWith(color: AppColors.danger)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.accept(request),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: AppColors.primaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                        ),
                      ),
                      child: Text('Accept', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => controller.toggleExpanded(request.id),
                  child: Text(
                    'Details',
                    style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryDark),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    if (isToday) return DateFormat('h:mm a').format(date);
    return DateFormat('MMM d').format(date);
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
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