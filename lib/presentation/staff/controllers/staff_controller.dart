import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/data/models/staff_model.dart';
import 'package:apartmate/domain/repositories/i_staff_repository.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:image_picker/image_picker.dart';

class StaffController extends GetxController {
  final IStaffRepository _staffRepository;
  StaffController(this._staffRepository);

  final staff = <StaffModel>[].obs;
  final isLoading = false.obs;

  // Add/Edit staff form state
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cnicCtrl = TextEditingController();
  final selectedRole = StaffRole.securityGuard.obs;
  final selectedShift = StaffShift.morning.obs;

  final photo = Rxn<File>();
  static const int maxPhotoSizeBytes = 3 * 1024 * 1024; // 3MB

  /// Non-null while editing an existing staff member; null while adding new.
  String? _editingStaffId;
  bool get isEditing => _editingStaffId != null;

  @override
  void onInit() {
    super.onInit();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    isLoading.value = true;
    try {
      final result = await _staffRepository.getStaff();
      staff.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  void setRole(StaffRole? role) {
    if (role != null) selectedRole.value = role;
  }

  void setShift(StaffShift? shift) {
    if (shift != null) selectedShift.value = shift;
  }

  void resetForm() {
    _editingStaffId = null;
    nameCtrl.clear();
    phoneCtrl.clear();
    cnicCtrl.clear();
    selectedRole.value = StaffRole.securityGuard;
    selectedShift.value = StaffShift.morning;
    photo.value = null;
  }

  /// Pre-fills the form with an existing staff member's data, ready for editing.
  void startEditing(StaffModel member) {
    _editingStaffId = member.id;
    nameCtrl.text = member.name;
    phoneCtrl.text = member.phone;
    cnicCtrl.text = member.cnic;
    selectedRole.value = member.role;
    selectedShift.value = member.shift;
    photo.value = member.photoPath != null ? File(member.photoPath!) : null;
  }

  Future<void> saveStaff() async {
    if (nameCtrl.text.trim().isEmpty) return;

    if (isEditing) {
      final index = staff.indexWhere((s) => s.id == _editingStaffId);
      final updated = staff[index].copyWith(
        name: nameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        cnic: cnicCtrl.text.trim(),
        role: selectedRole.value,
        shift: selectedShift.value,
        photoPath: photo.value?.path,
      );
      final saved = await _staffRepository.updateStaff(updated);
      staff[index] = saved;
    } else {
      final newStaff = StaffModel(
        id: 's-${DateTime.now().millisecondsSinceEpoch}',
        name: nameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        cnic: cnicCtrl.text.trim(),
        role: selectedRole.value,
        shift: selectedShift.value,
        photoPath: photo.value?.path,
      );
      final saved = await _staffRepository.addStaff(newStaff);
      staff.add(saved);
    }

    resetForm();
    Get.back();
  }

  Future<void> deleteStaff(String staffId) async {
    await _staffRepository.deleteStaff(staffId);
    staff.removeWhere((s) => s.id == staffId);
  }

  void goToDashboard() => Get.offAllNamed(AppRoutes.dashboard);

  @override
  void onClose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    cnicCtrl.dispose();
    super.onClose();
  }

  Future<void> pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    final file = File(picked.path);
    final sizeInBytes = await file.length();
    if (sizeInBytes > maxPhotoSizeBytes) {
      Get.snackbar('File too large', 'Photo must be under 3MB');
      return;
    }
    photo.value = file;
  }
}