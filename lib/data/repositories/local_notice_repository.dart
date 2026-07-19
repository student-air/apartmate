import 'package:apartmate/data/models/notice_model.dart';
import 'package:apartmate/domain/repositories/i_notice_repository.dart';

class LocalNoticeRepository implements INoticeRepository {
  final List<NoticeModel> _notices = [];

  @override
  Future<List<NoticeModel>> getNotices() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final sorted = List<NoticeModel>.from(_notices)..sort((a, b) => b.postedAt.compareTo(a.postedAt));
    return List.unmodifiable(sorted);
  }

  @override
  Future<NoticeModel> addNotice(NoticeModel notice) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _notices.add(notice);
    return notice;
  }
}