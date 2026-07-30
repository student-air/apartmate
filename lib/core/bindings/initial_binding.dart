import 'package:get/get.dart';
import 'package:apartmate/data/repositories/firebase_auth_repository.dart';
import 'package:apartmate/data/repositories/firebase_society_repository.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/data/repositories/firebase_staff_repository.dart';
import 'package:apartmate/domain/repositories/i_staff_repository.dart';
import 'package:apartmate/domain/repositories/i_dashboard_repository.dart';
import 'package:apartmate/data/repositories/local_dashboard_repository.dart';
import 'package:apartmate/data/repositories/local_update_repository.dart';
import 'package:apartmate/domain/repositories/i_update_repository.dart';
import 'package:apartmate/presentation/updates/controllers/updates_badge_controller.dart';
import 'package:apartmate/data/repositories/local_request_repository.dart';
import 'package:apartmate/domain/repositories/i_request_repository.dart';
import 'package:apartmate/data/repositories/local_resident_repository.dart';
import 'package:apartmate/domain/repositories/i_resident_repository.dart';
import 'package:apartmate/data/repositories/local_complaint_repository.dart';
import 'package:apartmate/domain/repositories/i_complaint_repository.dart';

/// Wires every repository interface to its concrete implementation.
///
/// This is the ONLY place that needs to change when a real backend
/// (Firebase, REST, etc.) replaces the local mock data sources — swap the
/// `Local...Repository()` on the right-hand side for e.g.
/// `FirebaseAuthRepository()` and every controller in the app keeps working
/// unmodified, because they only ever depend on the `I...Repository`
/// interfaces.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<IAuthRepository>(FirebaseAuthRepository(), permanent: true);
    Get.put<ISocietyRepository>(FirebaseSocietyRepository(), permanent: true);
    Get.put<IStaffRepository>(FirebaseStaffRepository(), permanent: true);
    Get.put<IDashboardRepository>(
      LocalDashboardRepository(Get.find<ISocietyRepository>(), Get.find<IStaffRepository>()),
      permanent: true,
    );
    Get.put<IUpdateRepository>(LocalUpdateRepository(), permanent: true);
    Get.put<UpdatesBadgeController>(UpdatesBadgeController(), permanent: true);
    Get.put<IRequestRepository>(LocalRequestRepository(), permanent: true);
    Get.put<IResidentRepository>(LocalResidentRepository(), permanent: true);
    Get.put<IComplaintRepository>(LocalComplaintRepository(), permanent: true);
  }
}