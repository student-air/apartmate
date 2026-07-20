import 'package:get/get.dart';
import 'package:apartmate/data/models/dashboard_stats_model.dart';
import 'package:apartmate/domain/repositories/i_dashboard_repository.dart';
import 'package:apartmate/routes/app_routes.dart';

class DashboardController extends GetxController {
  final IDashboardRepository _dashboardRepository;
  DashboardController(this._dashboardRepository);

  final stats = Rxn<DashboardStatsModel>();
  final isLoading = false.obs;

  static String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  void onInit() {
    super.onInit();
    _loadStats();
  }

  Future<void> _loadStats() async {
    isLoading.value = true;
    try {
      stats.value = await _dashboardRepository.getStats();
    } finally {
      isLoading.value = false;
    }
  }

  void goToBuildings() => Get.toNamed(AppRoutes.societyBuildings);
  void goToStaff() => Get.toNamed(AppRoutes.managementStaff);
  void goToNotices() => Get.toNamed(AppRoutes.notices);
  void goToProfile() => Get.toNamed(AppRoutes.profile);
}