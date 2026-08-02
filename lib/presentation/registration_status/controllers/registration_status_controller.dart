import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/routes/app_routes.dart';

class RegistrationStatusController extends GetxController {
  final ISocietyRepository _societyRepository;
  RegistrationStatusController(this._societyRepository);

  final society = Rxn<SocietyModel>();
  final isLoading = false.obs;

  bool get isApproved =>
      society.value?.registrationStatus == SocietyRegistrationStatus.approved;

  String get statusLabel {
    switch (society.value?.registrationStatus) {
      case SocietyRegistrationStatus.submitted:
        return 'Submitted';
      case SocietyRegistrationStatus.pendingReview:
        return 'Pending Review';
      case SocietyRegistrationStatus.approved:
        return 'Approved';
      default:
        return 'Pending Review';
    }
  }

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

  Future<void> refreshStatus() => _loadSociety();

  String get formattedDate {
    final date = society.value?.submittedAt;
    if (date == null) return '';
    return DateFormat('MMM d, yyyy').format(date);
  }

  String get joinCode => society.value?.joinCode ?? '——————';

  void continueSetup() {
  if (!isApproved) {
    AppSnackbar.info(
      'Still under review',
      'You can continue once your society registration is approved',
    );
    return;
  }
  Get.offAllNamed(AppRoutes.societyBuildings);
}
}