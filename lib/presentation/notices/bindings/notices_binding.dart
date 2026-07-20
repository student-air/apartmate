import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_notice_repository.dart';
import 'package:apartmate/presentation/notices/controllers/notices_controller.dart';

class NoticesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoticesController>(() => NoticesController(Get.find<INoticeRepository>()));
  }
}