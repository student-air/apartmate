import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/data/models/complaint_model.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/presentation/dashboard/controllers/dashboard_controller.dart';
import 'package:apartmate/domain/repositories/i_complaint_repository.dart';

class ComplaintsController extends GetxController with GetSingleTickerProviderStateMixin {
  final IComplaintRepository _complaintRepository;
  ComplaintsController(this._complaintRepository);

  late final TabController tabController;

  final complaints = <ComplaintModel>[].obs;
  final resolved = <ComplaintModel>[].obs;
  final isLoading = false.obs;
  final selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        selectedTab.value = tabController.index;
      }
    });
    loadAll();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> loadAll() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _complaintRepository.getComplaints(),
        _complaintRepository.getResolved(),
      ]);
      complaints.assignAll(results[0]);
      resolved.assignAll(results[1]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setStatus(String id, ComplaintStatus status) async {
    if (status == ComplaintStatus.resolved) {
      await markResolved(id);
      return;
    }

    final index = complaints.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final previous = complaints[index];
    complaints[index] = previous.copyWith(status: status);
    complaints.refresh();

    try {
      await _complaintRepository.updateComplaintStatus(id, status);
      _refreshDashboardCount();
    } catch (_) {
      complaints[index] = previous;
      complaints.refresh();
      AppSnackbar.error('Update failed', 'Could not update complaint status');
    }
  }

  Future<void> markResolved(String id) async {
    final index = complaints.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final previous = complaints[index];
    complaints.removeAt(index);
    final resolvedItem = previous.copyWith(status: ComplaintStatus.resolved);
    resolved.insert(0, resolvedItem);

    try {
      await _complaintRepository.resolveComplaint(id);
      _refreshDashboardCount();
    } catch (_) {
      resolved.removeWhere((e) => e.id == id);
      complaints.insert(index, previous);
      AppSnackbar.error('Update failed', 'Could not resolve complaint');
    }
  }

  Future<void> deleteComplaint(String id) async {
    final index = complaints.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final previous = complaints[index];
    complaints.removeAt(index);

    try {
      await _complaintRepository.deleteComplaint(id);
      _refreshDashboardCount();
    } catch (_) {
      complaints.insert(index, previous);
      AppSnackbar.error('Delete failed', 'Could not delete complaint');
    }
  }

  Future<void> deleteResolved(String id) async {
    final index = resolved.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final previous = resolved[index];
    resolved.removeAt(index);

    try {
      await _complaintRepository.deleteResolved(id);
    } catch (_) {
      resolved.insert(index, previous);
      AppSnackbar.error('Delete failed', 'Could not delete complaint');
    }
  }

  Future<void> clearAll() async {
    if (selectedTab.value == 0) {
      final previous = List<ComplaintModel>.from(complaints);
      complaints.clear();
      try {
        await _complaintRepository.clearAll();
        _refreshDashboardCount();
      } catch (_) {
        complaints.assignAll(previous);
        AppSnackbar.error('Clear failed', 'Could not clear complaints');
      }
    } else {
      final previous = List<ComplaintModel>.from(resolved);
      resolved.clear();
      try {
        await _complaintRepository.clearResolved();
      } catch (_) {
        resolved.assignAll(previous);
        AppSnackbar.error('Clear failed', 'Could not clear resolved');
      }
    }
  }

  void _refreshDashboardCount() {
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().refreshComplaintsCount();
    }
  }

  void confirmClearAll() {
    final isActiveTab = selectedTab.value == 0;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isActiveTab ? 'Clear all complaints?' : 'Clear all resolved?',
                style: AppTextStyles.h4,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isActiveTab
                    ? 'This will permanently remove every active complaint.'
                    : 'This will permanently remove every resolved complaint.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    clearAll();
                  },
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.white),
                  label: Text(
                    'Clear All',
                    style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}