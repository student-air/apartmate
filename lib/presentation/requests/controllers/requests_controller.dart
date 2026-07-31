import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/data/models/request_model.dart';
import 'package:apartmate/data/models/resident_model.dart';
import 'package:apartmate/data/models/owner_model.dart';
import 'package:apartmate/domain/repositories/i_request_repository.dart';
import 'package:apartmate/domain/repositories/i_resident_repository.dart';
import 'package:apartmate/domain/repositories/i_owner_repository.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/presentation/dashboard/controllers/dashboard_controller.dart';

class RequestsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final IRequestRepository _requestRepository;
  final IResidentRepository _residentRepository;
  final IOwnerRepository _ownerRepository;

  RequestsController(
    this._requestRepository,
    this._residentRepository,
    this._ownerRepository,
  );

  late final TabController tabController;

  final ownerRequests = <RequestModel>[].obs;
  final tenantRequests = <RequestModel>[].obs;
  final isLoading = false.obs;
  final selectedTab = 0.obs;
  final expandedRequestId = Rxn<String>();

  void toggleExpanded(String requestId) {
    expandedRequestId.value =
        expandedRequestId.value == requestId ? null : requestId;
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        selectedTab.value = tabController.index;
        expandedRequestId.value = null;
      }
    });
    loadRequests();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> loadRequests() async {
    isLoading.value = true;
    try {
      final result = await _requestRepository.getRequests();
      final pending =
          result.where((r) => r.status == RequestStatus.pending).toList();
      ownerRequests.assignAll(
        pending.where((r) => r.applicantType == RequestApplicantType.owner),
      );
      tenantRequests.assignAll(
        pending.where((r) => r.applicantType == RequestApplicantType.tenant),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => loadRequests();

  Future<void> accept(RequestModel request) async {
    try {
      await _requestRepository.updateStatus(request.id, RequestStatus.accepted);

      if (request.applicantType == RequestApplicantType.owner) {
        await _ownerRepository.addOwner(
          OwnerModel(
            id: 'own-${DateTime.now().millisecondsSinceEpoch}',
            name: request.tenantName,
            phone: request.phone,
            email: request.email,
            cnic: request.cnic,
            buildingName: request.buildingName,
            flatNumber: request.flatNumber,
          ),
        );
        AppSnackbar.success(
          'Accepted',
          '${request.tenantName} registered as an owner',
        );
      } else {
        await _residentRepository.addResident(
          ResidentModel(
            id: 'res-${DateTime.now().millisecondsSinceEpoch}',
            buildingId: request.buildingId,
            buildingName: request.buildingName,
            floor: request.floor,
            flatNumber: request.flatNumber,
            flatType: request.flatType,
            name: request.tenantName,
            cnic: request.cnic,
            phone: request.phone,
            email: request.email,
            residentsCount: request.residentsCount,
            allotmentDate: request.allotmentDate,
            leaseDurationMonths: request.leaseDurationMonths,
            rent: request.rent,
            profession: request.profession,
            employerCompany: request.employerCompany,
            previousAddress: request.previousAddress,
            emergencyContact: request.emergencyContact,
          ),
        );
        AppSnackbar.success(
          'Accepted',
          '${request.tenantName} registered as a resident',
        );
      }

      _removeFromLists(request.id);
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().refreshRequestCounts();
      }
    } catch (e) {
      AppSnackbar.error('Failed', 'Could not accept request: $e');
    }
  }

  Future<void> ignore(RequestModel request) async {
    try {
      await _requestRepository.deleteRequest(request.id);
      _removeFromLists(request.id);
      AppSnackbar.info('Removed', 'Request from ${request.tenantName} was removed');
    } catch (e) {
      AppSnackbar.error('Failed', 'Could not remove request: $e');
    }
  }

  void _removeFromLists(String id) {
    ownerRequests.removeWhere((r) => r.id == id);
    tenantRequests.removeWhere((r) => r.id == id);
    if (expandedRequestId.value == id) expandedRequestId.value = null;
  }
}