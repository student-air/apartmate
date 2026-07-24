import 'package:get/get.dart';
import 'package:apartmate/data/models/request_model.dart';
import 'package:apartmate/domain/repositories/i_request_repository.dart';

class RequestsController extends GetxController {
  final IRequestRepository _requestRepository;
  RequestsController(this._requestRepository);

  final requests = <RequestModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRequests();
  }

  Future<void> loadRequests() async {
    isLoading.value = true;
    try {
      final result = await _requestRepository.getRequests();
      requests.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => loadRequests();
}