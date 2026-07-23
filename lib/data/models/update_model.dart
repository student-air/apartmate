enum UpdateType { general, complaint, announcement }

class UpdateModel {
  final String id;
  final UpdateType type;
  final String title;
  final String description;
  final DateTime postedAt;

  /// The specific preset picked when composing (e.g. "Maintenance Alert",
  /// "Security Alert"). [type] stays as the coarse category used for the
  /// feed's color-coded pill; this is the more specific label shown instead
  /// of [type] when present.
  final String? category;

  const UpdateModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.postedAt,
    this.category,
  });
}