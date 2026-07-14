enum SocietyRegistrationStatus { submitted, pendingReview, approved }

/// Society profile submitted at registration time.
class SocietyModel {
  final String id;
  final String name;
  final String ownerName;
  final String address;
  final String city;
  final String country;
  final String contactNumber;
  final String? description;
  final SocietyRegistrationStatus registrationStatus;
  final DateTime submittedAt;

  const SocietyModel({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.address,
    required this.city,
    required this.country,
    required this.contactNumber,
    this.description,
    this.registrationStatus = SocietyRegistrationStatus.pendingReview,
    required this.submittedAt,
  });
}
