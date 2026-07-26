import 'package:apartmate/data/models/request_model.dart';
import 'package:apartmate/domain/repositories/i_request_repository.dart';

class LocalRequestRepository implements IRequestRepository {
  final List<RequestModel> _requests = [];

  @override
  Future<List<RequestModel>> getRequests() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final sorted = List<RequestModel>.from(_requests)..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
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