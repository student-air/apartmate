import 'package:get/get.dart';
import 'package:apartmate/data/models/update_model.dart';
import 'package:apartmate/domain/repositories/i_update_repository.dart';

class UpdatesController extends GetxController {
  final IUpdateRepository _updateRepository;
  UpdatesController(this._updateRepository);

  final updates = <UpdateModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUpdates();
  }

  Future<void> loadUpdates() async {
    isLoading.value = true;
    try {
      final result = await _updateRepository.getUpdates();
      updates.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() => loadUpdates();

  /// Removes a single update — called when a card is swiped away. The item
  /// is taken out of the list immediately so the swipe animation completes
  /// cleanly, then the delete is persisted; if that fails, the item is put
  /// back where it was.
  Future<void> deleteUpdate(String id) async {
    final index = updates.indexWhere((u) => u.id == id);
    if (index == -1) return;

    final removed = updates[index];
    updates.removeAt(index);
    try {
      await _updateRepository.deleteUpdate(id);
    } catch (_) {
      updates.insert(index, removed);
    }
  }

  /// Clears every update — called from the "Clear All" action.
  Future<void> clearAll() async {
    if (updates.isEmpty) return;
    final previous = List<UpdateModel>.from(updates);
    updates.clear();
    try {
      await _updateRepository.clearAll();
    } catch (_) {
      updates.assignAll(previous);
    }
  }
}