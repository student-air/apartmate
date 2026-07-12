import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';

class LocalSocietyRepository implements ISocietyRepository {
  SocietyModel? _society;

  @override
  Future<SocietyModel> registerSociety(SocietyModel society) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _society = society;
    return _society!;
  }

  @override
  Future<SocietyModel?> getCurrentSociety() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _society;
  }
}