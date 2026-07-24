import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_request_repository.dart';
import 'package:apartmate/presentation/requests/controllers/requests_controller.dart';

class RequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestsController>(
      () => RequestsController(Get.find<IRequestRepository>()),
    );
  }
}