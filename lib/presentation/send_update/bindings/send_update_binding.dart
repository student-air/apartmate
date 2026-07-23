import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/domain/repositories/i_update_repository.dart';
import 'package:apartmate/presentation/send_update/controllers/send_update_controller.dart';

class SendUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendUpdateController>(
      () => SendUpdateController(Get.find<IUpdateRepository>(), Get.find<ISocietyRepository>()),
    );
  }
}