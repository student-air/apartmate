import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_dashboard_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/domain/repositories/i_request_repository.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/domain/repositories/i_resident_repository.dart';
import 'package:apartmate/domain/repositories/i_complaint_repository.dart';
import 'package:apartmate/presentation/dashboard/controllers/dashboard_controller.dart';
import 'package:apartmate/domain/repositories/i_update_repository.dart';
import 'package:apartmate/domain/repositories/i_owner_repository.dart';
import 'package:apartmate/domain/repositories/i_committee_repository.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(
        Get.find<IDashboardRepository>(),
        Get.find<ISocietyRepository>(),
        Get.find<IComplaintRepository>(),
        Get.find<IRequestRepository>(),
        Get.find<IAuthRepository>(),
        Get.find<IResidentRepository>(),
        Get.find<IUpdateRepository>(),
        Get.find<IOwnerRepository>(),
        Get.find<ICommitteeRepository>(),
      ),
    );
  }
}