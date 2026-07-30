//import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  // ── Filters ──
  final buildings = <BuildingModel>[].obs;
  final selectedBuildingName = Rxn<String>();
  final selectedFloor = Rxn<int>();
  final rentFilter = PaymentFilter.all.obs;
  final maintenanceFilter = PaymentFilter.all.obs;
  final searchQuery = ''.obs;

  /// Floors available for the currently selected building filter, derived
  /// from actual resident data rather than BuildingDetailsModel, so the
  /// dropdown only ever shows floors that genuinely have a resident.
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
    selectedFloor.value = null; // reset floor when building changes
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

  /// Residents after applying all active filters.
  List<ResidentModel> get filteredResidents {
    final query = searchQuery.value.trim().toLowerCase();
    return residents.where((r) {
      if (selectedBuildingName.value != null && r.buildingName != selectedBuildingName.value) return false;
      if (selectedFloor.value != null && r.floor != selectedFloor.value) return false;
      if (rentFilter.value == PaymentFilter.paid && !r.rentPaid) return false;
      if (rentFilter.value == PaymentFilter.unpaid && r.rentPaid) return false;
      if (maintenanceFilter.value == PaymentFilter.paid && !r.maintenancePaid) return false;
      if (maintenanceFilter.value == PaymentFilter.unpaid && r.maintenancePaid) return false;
      if (query.isNotEmpty && !r.name.toLowerCase().contains(query)) return false;
      return true;
    }).toList();
  }

  /// Filtered residents grouped by building name, for the sectioned list view.
  Map<String, List<ResidentModel>> get groupedByBuilding {
    final map = <String, List<ResidentModel>>{};
    for (final r in filteredResidents) {
      map.putIfAbsent(r.buildingName, () => []).add(r);
    }
    return map;
  }

  final expandedResidentId = Rxn<String>();

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

  Future<void> deleteResident(String residentId) async {
  await _residentRepository.removeResident(residentId);
  residents.removeWhere((r) => r.id == residentId);
}

  Future<void> refresh() => _load();
}