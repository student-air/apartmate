import 'package:apartmate/data/models/request_model.dart';
import 'package:apartmate/domain/repositories/i_request_repository.dart';

class LocalRequestRepository implements IRequestRepository {
  final List<RequestModel> _requests = [
    RequestModel(
      id: 'request-demo-1',
      title: 'Leaking kitchen faucet',
      description: 'The kitchen tap in Flat 3B has been leaking steadily since last night. Water is pooling under the sink.',
      status: RequestStatus.pending,
      raisedBy: 'Bilal Ahmed (Flat 3B)',
      submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

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
}