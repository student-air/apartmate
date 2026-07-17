import 'package:get/get.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
//import 'package:apartmate/routes/app_routes.dart';

class SocietySetupController extends GetxController {
  final ISocietyRepository _societyRepository;
  SocietySetupController(this._societyRepository);

  final buildings = <BuildingModel>[].obs;
  final isLoading = false.obs;
  final newBuildingName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadBuildings();
  }

  Future<void> _loadBuildings() async {
    isLoading.value = true;
    try {
      final result = await _societyRepository.getBuildings();
      buildings.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  void setNewBuildingName(String value) => newBuildingName.value = value;

  Future<void> addBuilding() async {
    final trimmed = newBuildingName.value.trim();
    if (trimmed.isEmpty) return;
    final building = await _societyRepository.addBuilding(trimmed);
    buildings.add(building);
    newBuildingName.value = '';
  }

  Future<void> saveBuildingDetails(String buildingId, BuildingDetailsModel details) async {
    final updated = await _societyRepository.saveBuildingDetails(buildingId, details);
    final index = buildings.indexWhere((b) => b.id == buildingId);
    if (index != -1) buildings[index] = updated;
  }

  Future<void> renameBuilding(String buildingId, String newName) async {
    final updated = await _societyRepository.renameBuilding(buildingId, newName);
    final index = buildings.indexWhere((b) => b.id == buildingId);
    if (index != -1) buildings[index] = updated;
  }

  Future<void> deleteBuilding(String buildingId) async {
    await _societyRepository.deleteBuilding(buildingId);
    buildings.removeWhere((b) => b.id == buildingId);
  }

  void continueToNextStep() {
    // Placeholder — will point to Management Staff setup once that screen exists.
  }
}