import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_resident_repository.dart';
import 'package:apartmate/presentation/residents/controllers/residents_controller.dart';

class ResidentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResidentsController>(() => ResidentsController(Get.find<IResidentRepository>()));
  }
}