enum NoticeType { notice, complaint, announcement }

class NoticeModel {
  final String id;
  final NoticeType type;
  final String title;
  final String description;
  final DateTime postedAt;

  const NoticeModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.postedAt,
  });
}