import 'package:apartmate/data/models/dashboard_stats_model.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/domain/repositories/i_dashboard_repository.dart';
import 'package:apartmate/domain/repositories/i_staff_repository.dart';

class LocalDashboardRepository implements IDashboardRepository {
  final ISocietyRepository societyRepository;
  final IStaffRepository staffRepository;

  LocalDashboardRepository(this.societyRepository,this.staffRepository);

  @override
  Future<DashboardStatsModel> getStats() async {
    final buildings = await societyRepository.getBuildings();
    final staff = await staffRepository.getStaff();
    final totalFlats = buildings.fold<int>(0, (sum, b) => sum + (b.details?.totalApartments ?? 0)); 

    return DashboardStatsModel(
       buildings: buildings.length,
      totalFlats: totalFlats,
      mgmtStaff: staff.length,
      pendingRequests: 0, // Replace with actual pending requests count if available
    );
  }
}