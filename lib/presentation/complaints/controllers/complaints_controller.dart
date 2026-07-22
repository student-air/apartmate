import 'package:get/get.dart';
import 'package:apartmate/data/models/update_model.dart';
import 'package:apartmate/domain/repositories/i_update_repository.dart';

/// Reuses the same Updates data source, filtered down to UpdateType.complaint.
/// If complaints ever need their own fields (status, assignee, etc.) this
/// is the place to branch off into a dedicated model/repository.
class ComplaintsController extends GetxController {
  final IUpdateRepository _updateRepository;
  ComplaintsController(this._updateRepository);

  final complaints = <UpdateModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadComplaints();
  }

  Future<void> loadComplaints() async {
    isLoading.value = true;
    try {
      final all = await _updateRepository.getUpdates();
      complaints.assignAll(all.where((u) => u.type == UpdateType.complaint));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => loadComplaints();
}