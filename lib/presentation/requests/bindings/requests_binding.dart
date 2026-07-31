import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_request_repository.dart';
import 'package:apartmate/domain/repositories/i_resident_repository.dart';
import 'package:apartmate/domain/repositories/i_owner_repository.dart';
import 'package:apartmate/presentation/requests/controllers/requests_controller.dart';

class RequestsBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(
  () => RequestsController(
    Get.find<IRequestRepository>(),
    Get.find<IResidentRepository>(),
    Get.find<IOwnerRepository>(),
  ),
);
  }
}