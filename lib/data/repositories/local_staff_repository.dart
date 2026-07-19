import 'package:apartmate/data/models/staff_model.dart';
import 'package:apartmate/domain/repositories/i_staff_repository.dart';

class LocalStaffRepository implements IStaffRepository {
  final List<StaffModel> _staff = [];

  @override
  Future<List<StaffModel>> getStaff() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_staff);
  }

@override
  Future<StaffModel> addStaff(StaffModel staff) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _staff.add(staff);
    return staff;
  }

  @override
  Future<StaffModel> updateStaff(StaffModel staff) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _staff.indexWhere((s) => s.id == staff.id);
    if (index == -1) {
      throw StateError('Staff member not found: ${staff.id}');
    }
    _staff[index] = staff;
    return staff;
  }

  @override
  Future<void> deleteStaff(String staffId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _staff.removeWhere((s) => s.id == staffId);
  }
}