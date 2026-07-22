import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_update_repository.dart';
import 'package:apartmate/presentation/complaints/controllers/complaints_controller.dart';

class ComplaintsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComplaintsController>(
      () => ComplaintsController(Get.find<IUpdateRepository>()),
    );
  }
}