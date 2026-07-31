import 'package:get/get.dart';
import 'package:apartmate/presentation/committee/controllers/committee_controller.dart';
import 'package:apartmate/domain/repositories/i_committee_repository.dart';

class CommitteeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommitteeController(Get.find<ICommitteeRepository>()));
  }
}