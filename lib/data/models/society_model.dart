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

/// A single building within a society.
class BuildingModel {
  final String id;
  final String name;
  final BuildingDetailsModel? details;

  const BuildingModel({required this.id, required this.name, this.details});

  bool get isConfigured => details != null;

  BuildingModel copyWith({String? name, BuildingDetailsModel? details}) {
    return BuildingModel(
      id: id,
      name: name ?? this.name,
      details: details ?? this.details,
    );
  }
}

/// Structural configuration for a building (floors, flat mix, parking...).
class BuildingDetailsModel {
  final int totalFloors;
  final int flatsPerFloor;
  final int oneBedroomFlats;
  final int twoBedroomFlats;
  final int threeBedroomFlats;
  final bool hasParking;
  final int parkingSlots;
  final bool hasLift;

  const BuildingDetailsModel({
    this.totalFloors = 0,
    this.flatsPerFloor = 0,
    this.oneBedroomFlats = 0,
    this.twoBedroomFlats = 0,
    this.threeBedroomFlats = 0,
    this.hasParking = false,
    this.parkingSlots = 0,
    this.hasLift = false,
  });

  int get totalApartments => totalFloors * flatsPerFloor;
}