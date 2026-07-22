import 'package:apartmate/data/models/update_model.dart';
import 'package:apartmate/domain/repositories/i_update_repository.dart';

class LocalUpdateRepository implements IUpdateRepository {
  final List<UpdateModel> _updates = [];

  @override
  Future<List<UpdateModel>> getUpdates() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final sorted = List<UpdateModel>.from(_updates)..sort((a, b) => b.postedAt.compareTo(a.postedAt));
    return List.unmodifiable(sorted);
  }

  @override
  Future<UpdateModel> addUpdate(UpdateModel update) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _updates.add(update);
    return update;
  }
}