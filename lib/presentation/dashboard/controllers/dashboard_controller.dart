import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/routes/app_routes.dart';

class DashboardController extends GetxController {
  final ISocietyRepository _societyRepository;
  final IAuthRepository _authRepository;
  DashboardController(this._societyRepository, this._authRepository);

  final societyName = ''.obs;
  final isLoading = false.obs;

  static String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String get ownerFirstName {
    final fullName = _authRepository.currentUser?.fullName ?? 'there';
    return fullName.split(' ').first;
  }

  String get ownerInitials => _authRepository.currentUser?.initials ?? '?';

  @override
  void onInit() {
    super.onInit();
    _loadSociety();
  }

  Future<void> _loadSociety() async {
    isLoading.value = true;
    try {
      final society = await _societyRepository.getCurrentSociety();
      societyName.value = society?.name ?? '';
    } finally {
      isLoading.value = false;
    }
  }

  void goToEditSociety() => Get.toNamed(AppRoutes.societyBuildings);
  void goToAddStaff() => Get.toNamed(AppRoutes.managementStaff);
  void goToUpdates() => Get.toNamed(AppRoutes.sendNotice);
  void goToProfile() => Get.toNamed(AppRoutes.profile);
}