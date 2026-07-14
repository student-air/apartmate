import 'package:apartmate/data/models/society_model.dart';

/// Contract for society registration. Backed by [LocalSocietyRepository]
/// today; swap for a Firebase-backed implementation later without
/// touching any controller or view.
abstract class ISocietyRepository {
  Future<SocietyModel> registerSociety(SocietyModel society);
  Future<SocietyModel?> getCurrentSociety();
}
