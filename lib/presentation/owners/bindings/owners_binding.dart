import 'package:get/get.dart';
import 'package:apartmate/presentation/owners/controllers/owners_controller.dart';
import 'package:apartmate/domain/repositories/i_owner_repository.dart';

class OwnersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OwnersController(Get.find<IOwnerRepository>()));
  }
}