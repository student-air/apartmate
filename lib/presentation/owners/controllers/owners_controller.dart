import 'package:get/get.dart';
import 'package:apartmate/data/models/owner_model.dart';
import 'package:apartmate/domain/repositories/i_owner_repository.dart';

class OwnersController extends GetxController {
  final IOwnerRepository _repo;
  OwnersController(this._repo);

  final owners = <OwnerModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      owners.value = await _repo.getOwners();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => load();
}