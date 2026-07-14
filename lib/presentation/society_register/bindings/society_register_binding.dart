import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/presentation/society_register/controllers/society_register_controller.dart';

class SocietyRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SocietyRegisterController>(
      () => SocietyRegisterController(Get.find<ISocietyRepository>()),
    );
  }
}
