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

  Future<void> refresh() => loadUpdates();
}