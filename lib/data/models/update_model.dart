enum UpdateType { general, complaint, announcement }

class UpdateModel {
  final String id;
  final UpdateType type;
  final String title;
  final String description;
  final DateTime postedAt;

  const UpdateModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.postedAt,
  });
}