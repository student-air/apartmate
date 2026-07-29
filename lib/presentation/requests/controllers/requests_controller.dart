import 'package:get/get.dart';
import 'package:apartmate/data/models/request_model.dart';
import 'package:apartmate/data/models/resident_model.dart';
import 'package:apartmate/domain/repositories/i_request_repository.dart';
import 'package:apartmate/domain/repositories/i_resident_repository.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/presentation/dashboard/controllers/dashboard_controller.dart';

class RequestsController extends GetxController {
  final IRequestRepository _requestRepository;
  final IResidentRepository _residentRepository;
  RequestsController(this._requestRepository, this._residentRepository);

  final requests = <RequestModel>[].obs;
  final isLoading = false.obs;

  /// Tracks which request card is currently expanded (only one at a time).
  final expandedRequestId = Rxn<String>();

  void toggleExpanded(String requestId) {
    expandedRequestId.value = expandedRequestId.value == requestId ? null : requestId;
  }

  @override
  void onInit() {
    super.onInit();
    loadRequests();
  }

  Future<void> loadRequests() async {
    isLoading.value = true;
    try {
      final result = await _requestRepository.getRequests();
      requests.assignAll(result.where((r) => r.status == RequestStatus.pending));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => loadRequests();

  Future<void> accept(RequestModel request) async {
    try {
      await _requestRepository.updateStatus(request.id, RequestStatus.accepted);

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

      requests.removeWhere((r) => r.id == request.id);
      if (expandedRequestId.value == request.id) expandedRequestId.value = null;

      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().refreshRequestCounts();
      }

      AppSnackbar.success('Accepted', '${request.tenantName} registered as a resident');
      // TODO: notify tenant via email/SMS once tenant-facing app exists.
    } catch (e) {
      AppSnackbar.error('Failed', 'Could not accept request: $e');
    }
  }
  Future<void> ignore(RequestModel request) async {
    try {
      await _requestRepository.deleteRequest(request.id);
      requests.removeWhere((r) => r.id == request.id);
      if (expandedRequestId.value == request.id) expandedRequestId.value = null;
      AppSnackbar.info('Removed', 'Request from ${request.tenantName} was removed');
      // TODO: notify tenant to redo their application once tenant-facing app exists.
    } catch (e) {
      AppSnackbar.error('Failed', 'Could not remove request: $e');
    }
  }
}