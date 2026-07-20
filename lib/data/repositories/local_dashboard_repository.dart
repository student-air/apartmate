import 'package:apartmate/data/models/dashboard_stats_model.dart';
import 'package:apartmate/domain/repositories/i_dashboard_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/domain/repositories/i_staff_repository.dart';

class LocalDashboardRepository implements IDashboardRepository {
  final ISocietyRepository _societyRepository;
  final IStaffRepository _staffRepository;
  LocalDashboardRepository(this._societyRepository, this._staffRepository);

  @override
  Future<DashboardStatsModel> getStats() async {
    final buildings = await _societyRepository.getBuildings();
    final staff = await _staffRepository.getStaff();
    final totalFlats = buildings.fold<int>(0, (sum, b) => sum + (b.details?.totalApartments ?? 0));

    return DashboardStatsModel(
      buildings: buildings.length,
      totalFlats: totalFlats,
      mgmtStaff: staff.length,
      pendingRequests: 0, // wired once Tenant Requests exists
    );
  }
}