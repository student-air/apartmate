import 'package:apartmate/data/models/society_model.dart';

/// Contract for society registration. Backed by [LocalSocietyRepository]
/// today; swap for a Firebase-backed implementation later without
/// touching any controller or view.
abstract class ISocietyRepository {
  Future<SocietyModel> registerSociety(SocietyModel society);
  Future<SocietyModel?> getCurrentSociety();

  Future<List<BuildingModel>> getBuildings();
  Future<BuildingModel> addBuilding(String name);
  Future<BuildingModel> saveBuildingDetails(String buildingId, BuildingDetailsModel details);
  Future<BuildingModel> renameBuilding(String buildingId, String newName);
  Future<void> deleteBuilding(String buildingId);
}