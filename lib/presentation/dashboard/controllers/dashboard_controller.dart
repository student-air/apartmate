import 'package:get/get.dart';
import 'package:apartmate/data/models/dashboard_stats_model.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/domain/repositories/i_dashboard_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/routes/app_routes.dart';

class DashboardController extends GetxController {
  final IDashboardRepository _dashboardRepository;
  final ISocietyRepository _societyRepository;
  final IAuthRepository _authRepository;
  DashboardController(this._dashboardRepository, this._societyRepository, this._authRepository);

  final stats = Rxn<DashboardStatsModel>();
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
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _dashboardRepository.getStats(),
        _societyRepository.getCurrentSociety(),
      ]);
      stats.value = results[0] as DashboardStatsModel;
      societyName.value = (results[1] as dynamic)?.name ?? '';
    } finally {
      isLoading.value = false;
    }
  }

  void goToEditSociety() => Get.toNamed(AppRoutes.societyBuildings);
  void goToAddStaff() => Get.toNamed(AppRoutes.managementStaff);
  void goToSendNotice() => Get.toNamed(AppRoutes.sendNotice);
  void goToNotices() => Get.toNamed(AppRoutes.notices);
  void goToRequests() => Get.toNamed(AppRoutes.requests);
  void goToProfile() => Get.toNamed(AppRoutes.profile);
}