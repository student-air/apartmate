import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/routes/app_routes.dart';

class RegistrationStatusController extends GetxController {
  final ISocietyRepository _societyRepository;
  RegistrationStatusController(this._societyRepository);

  final society = Rxn<SocietyModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSociety();
  }

  Future<void> _loadSociety() async {
    isLoading.value = true;
    try {
      society.value = await _societyRepository.getCurrentSociety();
    } finally {
      isLoading.value = false;
    }
  }

  String get formattedDate {
    final date = society.value?.submittedAt;
    if (date == null) return '';
    return DateFormat('MMM d, yyyy').format(date);
  }

  void continueSetup() => Get.toNamed(AppRoutes.societyBuildings);
}