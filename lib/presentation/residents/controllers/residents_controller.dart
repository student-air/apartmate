import 'package:get/get.dart';
import 'package:apartmate/data/models/resident_model.dart';
import 'package:apartmate/domain/repositories/i_resident_repository.dart';

class ResidentsController extends GetxController {
  final IResidentRepository _residentRepository;
  ResidentsController(this._residentRepository);

  final residents = <ResidentModel>[].obs;
  final isLoading = false.obs;

  /// Residents grouped by building name, for the sectioned list view.
  Map<String, List<ResidentModel>> get groupedByBuilding {
    final map = <String, List<ResidentModel>>{};
    for (final r in residents) {
      map.putIfAbsent(r.buildingName, () => []).add(r);
    }
    return map;
  }

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    try {
      residents.value = await _residentRepository.getResidents();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => _load();
}