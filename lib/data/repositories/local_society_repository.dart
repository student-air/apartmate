import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';

class LocalSocietyRepository implements ISocietyRepository {
  SocietyModel? _society;
  final List<BuildingModel> _buildings = [];

  @override
  Future<SocietyModel> registerSociety(SocietyModel society) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _society = society;
    return _society!;
  }

  @override
  Future<SocietyModel?> getCurrentSociety() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _society;
  }

  @override
  Future<List<BuildingModel>> getBuildings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_buildings);
  }

  @override
  Future<BuildingModel> addBuilding(String name) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final building = BuildingModel(id: 'bldg-${DateTime.now().millisecondsSinceEpoch}', name: name);
    _buildings.add(building);
    return building;
  }

 @override
  Future<BuildingModel> saveBuildingDetails(String buildingId, BuildingDetailsModel details) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _buildings.indexWhere((b) => b.id == buildingId);
    if (index == -1) {
      throw StateError('Building not found: $buildingId');
    }
    final updated = _buildings[index].copyWith(details: details);
    _buildings[index] = updated;
    return updated;
  }

  @override
  Future<BuildingModel> renameBuilding(String buildingId, String newName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _buildings.indexWhere((b) => b.id == buildingId);
    if (index == -1) {
      throw StateError('Building not found: $buildingId');
    }
    final updated = _buildings[index].copyWith(name: newName);
    _buildings[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteBuilding(String buildingId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _buildings.removeWhere((b) => b.id == buildingId);
  }
}