import 'package:apartmate/data/models/request_model.dart';

abstract class IRequestRepository {
  Future<List<RequestModel>> getRequests();
  Future<RequestModel> addRequest(RequestModel request);
}