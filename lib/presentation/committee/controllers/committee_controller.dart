import 'package:get/get.dart';
import 'package:apartmate/data/models/committee_model.dart';
import 'package:apartmate/domain/repositories/i_committee_repository.dart';

class CommitteeController extends GetxController {
  final ICommitteeRepository _repo;
  CommitteeController(this._repo);

  final members = <CommitteeMemberModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      members.value = await _repo.getMembers();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => load();
}