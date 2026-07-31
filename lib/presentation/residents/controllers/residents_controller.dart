import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/data/models/resident_model.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/domain/repositories/i_resident_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';

enum PaymentFilter { all, paid, unpaid }

class ResidentsController extends GetxController {
  final IResidentRepository _residentRepository;
  final ISocietyRepository _societyRepository;
  ResidentsController(this._residentRepository, this._societyRepository);

  final residents = <ResidentModel>[].obs;
  final isLoading = false.obs;

  final buildings = <BuildingModel>[].obs;
  final selectedBuildingName = Rxn<String>();
  final selectedFloor = Rxn<int>();
  final rentFilter = PaymentFilter.all.obs;
  final maintenanceFilter = PaymentFilter.all.obs;
  final searchQuery = ''.obs;

  final expandedResidentId = Rxn<String>();

  List<int> get availableFloorsForFilter {
    if (selectedBuildingName.value == null) return [];
    final floors = residents
        .where((r) => r.buildingName == selectedBuildingName.value)
        .map((r) => r.floor)
        .toSet()
        .toList();
    floors.sort();
    return floors;
  }

  void setBuildingFilter(String? buildingName) {
    selectedBuildingName.value = buildingName;
    selectedFloor.value = null;
  }

  void setFloorFilter(int? floor) => selectedFloor.value = floor;
  void setRentFilter(PaymentFilter filter) => rentFilter.value = filter;
  void setMaintenanceFilter(PaymentFilter filter) => maintenanceFilter.value = filter;
  void setSearchQuery(String query) => searchQuery.value = query;

  void clearFilters() {
    selectedBuildingName.value = null;
    selectedFloor.value = null;
    rentFilter.value = PaymentFilter.all;
    maintenanceFilter.value = PaymentFilter.all;
    searchQuery.value = '';
  }

  bool get hasActiveFilters =>
      selectedBuildingName.value != null ||
      selectedFloor.value != null ||
      rentFilter.value != PaymentFilter.all ||
      maintenanceFilter.value != PaymentFilter.all ||
      searchQuery.value.trim().isNotEmpty;

  List<ResidentModel> get filteredResidents {
    final query = searchQuery.value.trim().toLowerCase();
    return residents.where((r) {
      if (selectedBuildingName.value != null && r.buildingName != selectedBuildingName.value) {
        return false;
      }
      if (selectedFloor.value != null && r.floor != selectedFloor.value) return false;
      if (rentFilter.value == PaymentFilter.paid && !r.rentPaid) return false;
      if (rentFilter.value == PaymentFilter.unpaid && r.rentPaid) return false;
      if (maintenanceFilter.value == PaymentFilter.paid && !r.maintenancePaid) return false;
      if (maintenanceFilter.value == PaymentFilter.unpaid && r.maintenancePaid) return false;
      if (query.isNotEmpty && !r.name.toLowerCase().contains(query)) return false;
      return true;
    }).toList();
  }

  Map<String, List<ResidentModel>> get groupedByBuilding {
    final map = <String, List<ResidentModel>>{};
    for (final r in filteredResidents) {
      map.putIfAbsent(r.buildingName, () => []).add(r);
    }
    return map;
  }

  void toggleExpanded(String residentId) {
    expandedResidentId.value = expandedResidentId.value == residentId ? null : residentId;
  }

  @override
  void onInit() {
    super.onInit();
    _load();
    _loadBuildings();
  }

  Future<void> _load() async {
    isLoading.value = true;
    try {
      residents.value = await _residentRepository.getResidents();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadBuildings() async {
    buildings.value = await _societyRepository.getBuildings();
  }

  Future<void> refresh() => _load();

  Future<void> toggleRentPaid(String id) async {
    final index = residents.indexWhere((e) => e.id == id);
    if (index == -1) return;
    final previous = residents[index];
    final next = previous.copyWith(rentPaid: !previous.rentPaid);
    residents[index] = next;
    residents.refresh();
    try {
      await _residentRepository.updatePaymentStatus(id, rentPaid: next.rentPaid);
    } catch (_) {
      residents[index] = previous;
      residents.refresh();
      AppSnackbar.error('Update failed', 'Could not update rent status');
    }
  }

  Future<void> toggleMaintenancePaid(String id) async {
    final index = residents.indexWhere((e) => e.id == id);
    if (index == -1) return;
    final previous = residents[index];
    final next = previous.copyWith(maintenancePaid: !previous.maintenancePaid);
    residents[index] = next;
    residents.refresh();
    try {
      await _residentRepository.updatePaymentStatus(id, maintenancePaid: next.maintenancePaid);
    } catch (_) {
      residents[index] = previous;
      residents.refresh();
      AppSnackbar.error('Update failed', 'Could not update maintenance status');
    }
  }

  Future<void> deleteResident(String residentId) async {
  await _residentRepository.removeResident(residentId);
  residents.value = residents.where((r) => r.id != residentId).toList();
}

  void confirmDeleteResident(ResidentModel resident) {
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
                'Delete resident?',
                style: AppTextStyles.h4,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'This will permanently remove "${resident.name}" from the residents list.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Get.back();
                    try {
                      await deleteResident(resident.id);
                      Get.back();
                      AppSnackbar.success('Deleted', '${resident.name} was removed');
                    } catch (e) {
                      AppSnackbar.error('Delete failed', e.toString());
                    }
                  },
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.white),
                  label: Text(
                    'Delete',
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