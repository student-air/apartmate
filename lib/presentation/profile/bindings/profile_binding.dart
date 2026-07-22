import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/presentation/profile/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find<IAuthRepository>(), Get.find<ISocietyRepository>()),
    );
  }
}