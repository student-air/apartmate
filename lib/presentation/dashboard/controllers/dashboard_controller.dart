import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/data/models/dashboard_stats_model.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/domain/repositories/i_dashboard_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/domain/repositories/i_complaint_repository.dart';
import 'package:apartmate/domain/repositories/i_request_repository.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/domain/repositories/i_resident_repository.dart';
import 'package:apartmate/domain/repositories/i_update_repository.dart';
import 'package:apartmate/data/models/request_model.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:apartmate/presentation/dashboard/widgets/edit_society_sheet.dart';

class DashboardController extends GetxController {
  final IDashboardRepository _dashboardRepository;
  final ISocietyRepository _societyRepository;
  final IComplaintRepository _complaintRepository;
  final IRequestRepository _requestRepository;
  final IAuthRepository _authRepository;
  final IResidentRepository _residentRepository;
  final IUpdateRepository _updateRepository;

  DashboardController(
    this._dashboardRepository,
    this._societyRepository,
    this._complaintRepository,
    this._requestRepository,
    this._authRepository,
    this._residentRepository,
    this._updateRepository,
  );

  final stats = Rxn<DashboardStatsModel>();
  final society = Rxn<SocietyModel>();
  final complaintsCount = 0.obs;
  final pendingRequestsCount = 0.obs;
  final residentsCount = 0.obs;
  final isLoading = false.obs;
  final totalFlats = 0.obs;
  final occupiedFlats = 0.obs;
  final recentActivity = <ActivityItem>[].obs;
  final weeklyComplaintCounts = List<int>.filled(7, 0).obs;

  static String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  static String get greetingAnimationAsset {
    if (greeting == 'Good Morning' || greeting == 'Good Afternoon') {
      return 'assets/lottie/sun.json';
    }
    return 'assets/lottie/moon.json';
  }

  String get ownerFirstName {
    final name = society.value?.ownerName.trim() ?? '';
    if (name.isEmpty) return '';
    return name.split(' ').first;
  }

  String get ownerInitials {
    final name = society.value?.ownerName.trim() ?? '';
    if (name.isEmpty) return '';
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  String get societyNameText => society.value?.name ?? '';

  String get roleDisplay {
    final role = _authRepository.currentUser?.role ?? '';
    if (role.trim().isEmpty) return 'Society Admin';
    return role[0].toUpperCase() + role.substring(1);
  }

  double get occupancyPercent {
    if (totalFlats.value == 0) return 0;
    return (occupiedFlats.value / totalFlats.value).clamp(0.0, 1.0);
  }

  @override
  void onInit() {
    super.onInit();
    _loadStats();
    _loadSociety();
    _loadComplaintsCount();
    _loadPendingRequestsCount();
    _loadResidentsCount();
    _loadOccupancy();
    _loadRecentActivity();
    _loadWeeklyComplaints();
  }

  @override
  void onReady() {
    super.onReady();
    _loadComplaintsCount();
  }

  Future<void> _loadStats() async {
    isLoading.value = true;
    try {
      stats.value = await _dashboardRepository.getStats();
      totalFlats.value = stats.value?.totalFlats ?? 0;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadOccupancy() async {
    final s = await _dashboardRepository.getStats();
    totalFlats.value = s.totalFlats;
    final residents = await _residentRepository.getResidents();
    occupiedFlats.value = residents.length;
  }

  Future<void> _loadRecentActivity() async {
    final complaints = await _complaintRepository.getComplaints();
    final updates = await _updateRepository.getUpdates();

    final items = <ActivityItem>[];

    for (final c in complaints) {
      items.add(
        ActivityItem(
          icon: Icons.report_problem_rounded,
          iconColor: AppColors.warning,
          title: 'New complaint: ${c.title}',
          timeLabel: _relativeTime(c.postedAt),
          at: c.postedAt,
        ),
      );
    }
    for (final u in updates) {
      items.add(
        ActivityItem(
          icon: Icons.campaign_rounded,
          iconColor: AppColors.accentGreenDark,
          title: 'Update posted: ${u.title}',
          timeLabel: _relativeTime(u.postedAt),
          at: u.postedAt,
        ),
      );
    }

    items.sort((a, b) => b.at.compareTo(a.at));
    recentActivity.value = items.take(5).toList();
  }

  Future<void> _loadWeeklyComplaints() async {
    final complaints = await _complaintRepository.getComplaints();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final counts = List<int>.filled(7, 0);

    for (final c in complaints) {
      final d = DateTime(c.postedAt.year, c.postedAt.month, c.postedAt.day);
      final diff = today.difference(d).inDays;
      if (diff >= 0 && diff < 7) {
        // index 0 = 6 days ago … index 6 = today
        counts[6 - diff]++;
      }
    }
    weeklyComplaintCounts.value = counts;
  }

  String _relativeTime(DateTime at) {
    final diff = DateTime.now().difference(at);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  Future<void> _loadSociety() async {
    society.value = await _societyRepository.getCurrentSociety();
  }

  Future<void> _loadComplaintsCount() async {
    final list = await _complaintRepository.getComplaints();
    complaintsCount.value = list.length;
  }

  Future<void> _loadPendingRequestsCount() async {
    final requests = await _requestRepository.getRequests();
    pendingRequestsCount.value =
        requests.where((r) => r.status == RequestStatus.pending).length;
  }

  Future<void> _loadResidentsCount() async {
    final residents = await _residentRepository.getResidents();
    residentsCount.value = residents.length;
  }

  Future<void> refreshSociety() => _loadSociety();

  Future<void> refreshRequestCounts() async {
    await Future.wait([
      _loadPendingRequestsCount(),
      _loadResidentsCount(),
    ]);
  }

  void goToEditSociety() => showEditSocietySheet();
  void goToAddStaff() => Get.toNamed(AppRoutes.managementStaff);
  void goToResidents() => Get.toNamed(AppRoutes.residents);
  void goToUpdates() => Get.toNamed(AppRoutes.updates);
  void goToProfile() => Get.toNamed(AppRoutes.profile);
  void goToBuildings() => Get.toNamed(AppRoutes.societyBuildings);
  void goToComplaints() => Get.toNamed(AppRoutes.complaints);
  void goToRequests() => Get.toNamed(AppRoutes.requests);

  Future<void> logout() async {
    await _authRepository.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  void confirmLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'You will need to sign in again to access your account.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              logout();
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Future<void> refreshComplaintsCount() => _loadComplaintsCount();

  Future<void> refreshAll() async {
    await Future.wait([
      _loadStats(),
      _loadSociety(),
      _loadComplaintsCount(),
      _loadPendingRequestsCount(),
      _loadResidentsCount(),
      _loadOccupancy(),
      _loadRecentActivity(),
      _loadWeeklyComplaints(),
    ]);
  }
}

class ActivityItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String timeLabel;
  final DateTime at;

  const ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.timeLabel,
    required this.at,
  });
}