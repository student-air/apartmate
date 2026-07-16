import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/presentation/registration_status/controllers/registration_status_controller.dart';

class RegistrationStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistrationStatusController>(
      () => RegistrationStatusController(Get.find<ISocietyRepository>()),
    );
  }
}