import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/presentation/society_setup/controllers/society_setup_controller.dart';

class SocietySetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SocietySetupController>(
      () => SocietySetupController(Get.find<ISocietyRepository>()),
      fenix: true,
    );
  }
}