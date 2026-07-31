import 'package:apartmate/data/models/request_model.dart';
import 'package:apartmate/domain/repositories/i_request_repository.dart';

class LocalRequestRepository implements IRequestRepository {
  final List<RequestModel> _requests = [];

  LocalRequestRepository() {
    _seedSampleRequests();
  }

  void _seedSampleRequests() {
    final now = DateTime.now();
    _requests.addAll([
      // ── Tenant requests (3) ──
      RequestModel(
        id: 'req-sample-1',
        buildingId: 'bldg-sample-1',
        buildingName: 'Building B',
        floor: 2,
        flatNumber: 'Flat 204',
        flatType: '2-Bedroom',
        tenantName: 'Zain Ahmed',
        cnic: '42101-8765432-1',
        phone: '+92 312 9876543',
        email: 'zain@email.com',
        residentsCount: 4,
        allotmentDate: DateTime(2025, 11, 1),
        leaseDurationMonths: 12,
        rent: 45000,
        profession: 'Software Engineer',
        employerCompany: 'TechSoft Pvt Ltd, Karachi',
        previousAddress: 'Block 5, Gulshan-e-Iqbal, Karachi',
        emergencyContact: '+92 300 1112233 (Brother)',
        status: RequestStatus.pending,
        submittedAt: now.subtract(const Duration(hours: 3)),
        applicantType: RequestApplicantType.tenant,
      ),
      RequestModel(
        id: 'req-sample-2',
        buildingId: 'bldg-sample-1',
        buildingName: 'Fortune Tower A',
        floor: 5,
        flatNumber: 'Flat 5A',
        flatType: '3-Bedroom',
        tenantName: 'Sara Khan',
        cnic: '42201-1234567-8',
        phone: '+92 300 9876543',
        email: 'sara.khan@example.com',
        residentsCount: 2,
        allotmentDate: now.add(const Duration(days: 10)),
        leaseDurationMonths: 6,
        rent: 38000,
        profession: 'Doctor',
        employerCompany: 'Aga Khan Hospital',
        previousAddress: 'DHA Phase 5, Karachi',
        emergencyContact: '+92 321 4445566 (Spouse)',
        status: RequestStatus.pending,
        submittedAt: now.subtract(const Duration(days: 1)),
        applicantType: RequestApplicantType.tenant,
      ),
      RequestModel(
        id: 'req-sample-3',
        buildingId: 'bldg-sample-2',
        buildingName: 'Fortune Tower B',
        floor: 2,
        flatNumber: 'Flat 2C',
        flatType: '1-Bedroom',
        tenantName: 'Bilal Sheikh',
        cnic: '35201-9988776-5',
        phone: '+92 333 5551234',
        email: 'bilal.sheikh@example.com',
        residentsCount: 3,
        allotmentDate: now.add(const Duration(days: 2)),
        leaseDurationMonths: 12,
        rent: 52000,
        profession: 'Marketing Manager',
        employerCompany: 'Unilever Pakistan',
        previousAddress: 'North Nazimabad, Karachi',
        emergencyContact: '+92 345 7778899 (Father)',
        status: RequestStatus.pending,
        submittedAt: now.subtract(const Duration(days: 2)),
        applicantType: RequestApplicantType.tenant,
      ),

      // ── Owner requests (2) ──
      RequestModel(
        id: 'req-owner-1',
        buildingId: 'bldg-sample-1',
        buildingName: 'Fortune Tower A',
        floor: 3,
        flatNumber: 'Flat 3B',
        flatType: '2-Bedroom',
        tenantName: 'Imran Malik',
        cnic: '42101-5544332-1',
        phone: '+92 301 2223344',
        email: 'imran.malik@email.com',
        residentsCount: 1,
        allotmentDate: DateTime(2025, 12, 1),
        leaseDurationMonths: 0,
        rent: 0,
        profession: 'Business Owner',
        employerCompany: 'Malik Traders',
        previousAddress: 'Clifton Block 4, Karachi',
        emergencyContact: '+92 300 9988776 (Wife)',
        status: RequestStatus.pending,
        submittedAt: now.subtract(const Duration(hours: 5)),
        applicantType: RequestApplicantType.owner,
      ),
      RequestModel(
        id: 'req-owner-2',
        buildingId: 'bldg-sample-2',
        buildingName: 'Fortune Tower B',
        floor: 7,
        flatNumber: 'Flat 7A',
        flatType: '3-Bedroom',
        tenantName: 'Nadia Hussain',
        cnic: '42201-7788990-3',
        phone: '+92 333 4455667',
        email: 'nadia.hussain@email.com',
        residentsCount: 1,
        allotmentDate: DateTime(2026, 1, 15),
        leaseDurationMonths: 0,
        rent: 0,
        profession: 'Architect',
        employerCompany: 'Hussain Design Studio',
        previousAddress: 'PECHS Block 2, Karachi',
        emergencyContact: '+92 321 1122334 (Brother)',
        status: RequestStatus.pending,
        submittedAt: now.subtract(const Duration(days: 1, hours: 4)),
        applicantType: RequestApplicantType.owner,
      ),
    ]);
  }

  @override
  Future<List<RequestModel>> getRequests() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final sorted = List<RequestModel>.from(_requests)
      ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    return List.unmodifiable(sorted);
  }

  @override
  Future<RequestModel> addRequest(RequestModel request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _requests.add(request);
    return request;
  }

  @override
  Future<RequestModel> updateStatus(String requestId, RequestStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index == -1) {
      throw StateError('Request not found: $requestId');
    }
    final updated = _requests[index].copyWith(status: status);
    _requests[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _requests.removeWhere((r) => r.id == requestId);
  }
}