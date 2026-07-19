import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:apartmate/presentation/society_setup/controllers/society_setup_controller.dart';

class BuildingDetailController extends GetxController {
  late final BuildingModel building;

  final totalFloorsCtrl = TextEditingController();
  final flatsPerFloorCtrl = TextEditingController();
  final bed1Ctrl = TextEditingController();
  final bed2Ctrl = TextEditingController();
  final bed3Ctrl = TextEditingController();
  final parkingSlotsCtrl = TextEditingController();
  final buildingNameCtrl = TextEditingController();
  final buildingNameFocusNode = FocusNode();

  final hasParking = false.obs;
  final hasLift = false.obs;
  final totalApartments = 0.obs;

  final bed1Count = 0.obs;
  final bed2Count = 0.obs;
  final bed3Count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    building = Get.arguments as BuildingModel;
    buildingNameCtrl.text = building.name;
    final d = building.details;
    if (d != null) {
      totalFloorsCtrl.text = d.totalFloors > 0 ? '${d.totalFloors}' : '';
      flatsPerFloorCtrl.text = d.flatsPerFloor > 0 ? '${d.flatsPerFloor}' : '';
      bed1Ctrl.text = d.oneBedroomFlats > 0 ? '${d.oneBedroomFlats}' : '';
      bed2Ctrl.text = d.twoBedroomFlats > 0 ? '${d.twoBedroomFlats}' : '';
      bed3Ctrl.text = d.threeBedroomFlats > 0 ? '${d.threeBedroomFlats}' : '';
      parkingSlotsCtrl.text = d.parkingSlots > 0 ? '${d.parkingSlots}' : '';
      hasParking.value = d.hasParking;
      hasLift.value = d.hasLift;
    }
    _recalculateTotal();
    _recalculateBedCounts();
    totalFloorsCtrl.addListener(_recalculateTotal);
    flatsPerFloorCtrl.addListener(_recalculateTotal);
    bed1Ctrl.addListener(_recalculateBedCounts);
    bed2Ctrl.addListener(_recalculateBedCounts);
    bed3Ctrl.addListener(_recalculateBedCounts);
  }

  void _recalculateTotal() {
    final floors = int.tryParse(totalFloorsCtrl.text) ?? 0;
    final flats = int.tryParse(flatsPerFloorCtrl.text) ?? 0;
    totalApartments.value = floors * flats;
  }
  
  void _recalculateBedCounts() {
    bed1Count.value = int.tryParse(bed1Ctrl.text) ?? 0;
    bed2Count.value = int.tryParse(bed2Ctrl.text) ?? 0;
    bed3Count.value = int.tryParse(bed3Ctrl.text) ?? 0;
  }

  void toggleParking(bool value) => hasParking.value = value;
  void toggleLift(bool value) => hasLift.value = value;

Future<void> save() async {
    final newName = buildingNameCtrl.text.trim();
    if (newName.isNotEmpty && newName != building.name) {
      await Get.find<SocietySetupController>().renameBuilding(building.id, newName);
    }

    final details = BuildingDetailsModel(
      totalFloors: int.tryParse(totalFloorsCtrl.text) ?? 0,
      flatsPerFloor: int.tryParse(flatsPerFloorCtrl.text) ?? 0,
      oneBedroomFlats: int.tryParse(bed1Ctrl.text) ?? 0,
      twoBedroomFlats: int.tryParse(bed2Ctrl.text) ?? 0,
      threeBedroomFlats: int.tryParse(bed3Ctrl.text) ?? 0,
      hasParking: hasParking.value,
      parkingSlots: int.tryParse(parkingSlotsCtrl.text) ?? 0,
      hasLift: hasLift.value,
    );
    await Get.find<SocietySetupController>().saveBuildingDetails(building.id, details);
    AppSnackbar.success('Done', ' Details saved successfully');
    Get.offNamed(AppRoutes.societyBuildings);
  }

  
  @override
  void onClose() {
    totalFloorsCtrl.dispose();
    flatsPerFloorCtrl.dispose();
    bed1Ctrl.dispose();
    bed2Ctrl.dispose();
    bed3Ctrl.dispose();
    parkingSlotsCtrl.dispose();
    super.onClose();
    buildingNameFocusNode.dispose();
  }
}