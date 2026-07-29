enum ComplaintStatus { pending, underReview, resolved }

class ComplaintModel {
  final String id;
  final String category;
  final String title;
  final String description;
  final DateTime postedAt;
  final ComplaintStatus status;

  const ComplaintModel({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.postedAt,
    this.status = ComplaintStatus.pending,
  });

  ComplaintModel copyWith({
    String? category,
    String? title,
    String? description,
    DateTime? postedAt,
    ComplaintStatus? status,
  }) {
    return ComplaintModel(
      id: id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      postedAt: postedAt ?? this.postedAt,
      status: status ?? this.status,
    );
  }
}