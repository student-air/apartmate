import 'package:apartmate/data/models/dashboard_stats_model.dart';

abstract class IDashboardRepository {
  Future<DashboardStatsModel> getStats();
}