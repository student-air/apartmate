import 'package:apartmate/data/models/resident_model.dart';

abstract class IResidentRepository {
  Future<List<ResidentModel>> getResidents();
  Future<ResidentModel> addResident(ResidentModel resident);
  Future<void> removeResident(String residentId);
}