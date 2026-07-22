// import 'package:get/get.dart';
// import 'package:apartmate/domain/repositories/i_auth_repository.dart';
// import 'package:apartmate/domain/repositories/i_society_repository.dart';
// import 'package:apartmate/routes/app_routes.dart';

// class DashboardController extends GetxController {
//   final ISocietyRepository _societyRepository;
//   final IAuthRepository _authRepository;
//   DashboardController(this._societyRepository, this._authRepository);

//   final societyName = ''.obs;
//   final isLoading = false.obs;

//   static String get greeting {
//     final hour = DateTime.now().hour;
//     if (hour < 12) return 'Good Morning';
//     if (hour < 17) return 'Good Afternoon';
//     return 'Good Evening';
//   }

//   String get ownerFirstName {
//     final fullName = _authRepository.currentUser?.fullName ?? 'there';
//     return fullName.split(' ').first;
//   }

//   String get ownerInitials => _authRepository.currentUser?.initials ?? '?';

//   @override
//   void onInit() {
//     super.onInit();
//     _loadSociety();
//   }

//   Future<void> _loadSociety() async {
//     isLoading.value = true;
//     try {
//       final society = await _societyRepository.getCurrentSociety();
//       societyName.value = society?.name ?? '';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void goToEditSociety() => Get.toNamed(AppRoutes.societyBuildings);
//   void goToAddStaff() => Get.toNamed(AppRoutes.managementStaff);
//   void goToUpdates() => Get.toNamed(AppRoutes.sendNotice);
//   void goToProfile() => Get.toNamed(AppRoutes.profile);
// }

import 'package:get/get.dart';
import 'package:apartmate/data/models/dashboard_stats_model.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/domain/repositories/i_dashboard_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/routes/app_routes.dart';

class DashboardController extends GetxController {
  final IDashboardRepository _dashboardRepository;
  final ISocietyRepository _societyRepository;
  DashboardController(this._dashboardRepository, this._societyRepository);

  final stats = Rxn<DashboardStatsModel>();
  final society = Rxn<SocietyModel>();
  final isLoading = false.obs;

  static String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  /// First name pulled from the owner name entered at society registration.
  /// Empty until the society has loaded.
  String get ownerFirstName {
    final name = society.value?.ownerName.trim() ?? '';
    if (name.isEmpty) return '';
    return name.split(' ').first;
  }

  /// Initials pulled from the registered owner name, e.g. "Ahmed Khan" -> "AK".
  String get ownerInitials {
    final name = society.value?.ownerName.trim() ?? '';
    if (name.isEmpty) return '';
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  /// Registered society name, shown under the greeting.
  String get societyNameText => society.value?.name ?? '';

  @override
  void onInit() {
    super.onInit();
    _loadStats();
    _loadSociety();
  }

  Future<void> _loadStats() async {
    isLoading.value = true;
    try {
      stats.value = await _dashboardRepository.getStats();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadSociety() async {
    society.value = await _societyRepository.getCurrentSociety();
  }

  void goToEditSociety() => Get.toNamed(AppRoutes.societyRegister); // TODO: point to a dedicated edit-society screen if you build one
  void goToAddStaff() => Get.toNamed(AppRoutes.managementStaff);
  void goToUpdates() => Get.toNamed(AppRoutes.sendNotice);
  void goToProfile() => Get.toNamed(AppRoutes.profile);
}