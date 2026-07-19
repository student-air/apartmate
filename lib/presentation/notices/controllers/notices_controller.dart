import 'package:get/get.dart';
import 'package:apartmate/data/models/notice_model.dart';
import 'package:apartmate/domain/repositories/i_notice_repository.dart';  

class NoticesController extends GetxController {
  final INoticeRepository _noticeRepository;
  NoticesController(this._noticeRepository);

  final notices = <NoticeModel>[].obs;
  final isLoading = false.obs;
  final selectedFilter = Rxn<NoticeType>(); // null = "All"

  @override
  void onInit() {
    super.onInit();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    isLoading.value = true;
    try {
      final result = await _noticeRepository.getNotices();
      notices.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(NoticeType? type) => selectedFilter.value = type;

  List<NoticeModel> get filteredNotices {
    if (selectedFilter.value == null) return notices;
    return notices.where((n) => n.type == selectedFilter.value).toList();
  }
}