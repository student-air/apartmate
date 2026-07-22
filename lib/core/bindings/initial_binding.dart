import 'package:get/get.dart';
import 'package:apartmate/data/repositories/local_auth_repository.dart';
import 'package:apartmate/data/repositories/local_society_repository.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/data/repositories/local_staff_repository.dart';
import 'package:apartmate/domain/repositories/i_staff_repository.dart';
import 'package:apartmate/domain/repositories/i_dashboard_repository.dart';
import 'package:apartmate/data/repositories/local_dashboard_repository.dart';
import 'package:apartmate/data/repositories/local_update_repository.dart';
import 'package:apartmate/domain/repositories/i_update_repository.dart';

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
    Get.put<IAuthRepository>(LocalAuthRepository(), permanent: true);
    Get.put<ISocietyRepository>(LocalSocietyRepository(), permanent: true);
    Get.put<IStaffRepository>(LocalStaffRepository(), permanent: true);
    Get.put<IDashboardRepository>(
      LocalDashboardRepository(Get.find<ISocietyRepository>(), Get.find<IStaffRepository>()),
      permanent: true,
    );
    Get.put<IUpdateRepository>(LocalUpdateRepository(), permanent: true);
  }
}
