import 'package:apartmate/data/models/notice_model.dart';

abstract class INoticeRepository {
  Future<List<NoticeModel>> getNotices();
  Future<NoticeModel> addNotice(NoticeModel notice);
}