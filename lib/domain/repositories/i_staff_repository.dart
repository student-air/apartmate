import 'package:apartmate/data/models/staff_model.dart';

/// Contract for managing society staff. Backed by [LocalStaffRepository]
/// today; swap for a Firebase-backed implementation later without
/// touching any controller or view.
abstract class IStaffRepository {
  Future<List<StaffModel>> getStaff();
  Future<StaffModel> addStaff(StaffModel staff);
  Future<StaffModel> updateStaff(StaffModel staff);
  Future<void> deleteStaff(String staffId);
}