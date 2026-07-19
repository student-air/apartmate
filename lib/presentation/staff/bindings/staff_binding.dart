import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_staff_repository.dart';
import 'package:apartmate/presentation/staff/controllers/staff_controller.dart';

class StaffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaffController>(() => StaffController(Get.find<IStaffRepository>()));
  }
}