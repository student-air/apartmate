import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/domain/repositories/i_dashboard_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/presentation/dashboard/controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(
        Get.find<IDashboardRepository>(),
        Get.find<ISocietyRepository>(),
        Get.find<IAuthRepository>(),
      ),
    );
  }
}