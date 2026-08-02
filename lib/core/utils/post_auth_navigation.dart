import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/routes/app_routes.dart';

Future<void> navigateAfterAuth() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    Get.offAllNamed(AppRoutes.login);
    return;
  }

  final society = await Get.find<ISocietyRepository>().getCurrentSociety();

  if (society == null) {
    Get.offAllNamed(AppRoutes.societyRegister);
    return;
  }

  if (society.registrationStatus != SocietyRegistrationStatus.approved) {
    Get.offAllNamed(AppRoutes.registrationStatus);
    return;
  }

  final buildings = await Get.find<ISocietyRepository>().getBuildings();
if (buildings.isEmpty) {
  Get.offAllNamed(AppRoutes.societyBuildings);
  return;
}
Get.offAllNamed(AppRoutes.dashboard);

  // Approved → main app
  Get.offAllNamed(AppRoutes.dashboard);
}