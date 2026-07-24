enum RequestStatus { pending, inProgress, resolved }

class RequestModel {
  final String id;
  final String title;
  final String description;
  final RequestStatus status;
  final String? raisedBy;
  final DateTime submittedAt;

  RequestModel({
 required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.submittedAt,
    this.raisedBy,
  });
}