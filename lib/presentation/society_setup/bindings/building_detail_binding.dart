import 'package:get/get.dart';
import 'package:apartmate/presentation/society_setup/controllers/building_detail_controller.dart';

class BuildingDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuildingDetailController>(() => BuildingDetailController());
  }
}