import 'package:apartmate/data/models/resident_model.dart';
import 'package:apartmate/domain/repositories/i_resident_repository.dart';

class LocalResidentRepository implements IResidentRepository {
  final List<ResidentModel> _residents = [];

  @override
  Future<List<ResidentModel>> getResidents() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_residents);
  }

  @override
  Future<ResidentModel> addResident(ResidentModel resident) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _residents.add(resident);
    return resident;
  }

  @override
  Future<void> removeResident(String residentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _residents.removeWhere((r) => r.id == residentId);
  }

  @override
  Future<ResidentModel> updatePaymentStatus(String residentId, {bool? rentPaid, bool? maintenancePaid}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _residents.indexWhere((r) => r.id == residentId);
    if (index == -1) {
      throw StateError('Resident not found: $residentId');
    }
    final updated = _residents[index].copyWith(rentPaid: rentPaid, maintenancePaid: maintenancePaid);
    _residents[index] = updated;
    return updated;
  }
}