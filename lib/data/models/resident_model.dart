class ResidentModel {
  final String id;
  final String buildingId;
  final String buildingName;
  final int floor;
  final String flatNumber;
  final String flatType;
  final String name;
  final String cnic;
  final String phone;
  final String email;
  final int residentsCount;
  final DateTime allotmentDate;
  final int leaseDurationMonths;
  final double rent;
  final String profession;
  final String employerCompany;
  final String previousAddress;
  final String emergencyContact;
  final bool rentPaid;
  final bool maintenancePaid;

  const ResidentModel({
    required this.id,
    required this.buildingId,
    required this.buildingName,
    required this.floor,
    required this.flatNumber,
    required this.flatType,
    required this.name,
    required this.cnic,
    required this.phone,
    required this.email,
    required this.residentsCount,
    required this.allotmentDate,
    required this.leaseDurationMonths,
    required this.rent,
    required this.profession,
    required this.employerCompany,
    required this.previousAddress,
    required this.emergencyContact,
    this.rentPaid = false,
    this.maintenancePaid = false,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    final letters = parts.take(2).map((e) => e.isNotEmpty ? e[0] : '').join();
    return letters.isEmpty ? '?' : letters.toUpperCase();
  }

  ResidentModel copyWith({bool? rentPaid, bool? maintenancePaid}) {
    return ResidentModel(
      id: id,
      buildingId: buildingId,
      buildingName: buildingName,
      floor: floor,
      flatNumber: flatNumber,
      flatType: flatType,
      name: name,
      cnic: cnic,
      phone: phone,
      email: email,
      residentsCount: residentsCount,
      allotmentDate: allotmentDate,
      leaseDurationMonths: leaseDurationMonths,
      rent: rent,
      profession: profession,
      employerCompany: employerCompany,
      previousAddress: previousAddress,
      emergencyContact: emergencyContact,
      rentPaid: rentPaid ?? this.rentPaid,
      maintenancePaid: maintenancePaid ?? this.maintenancePaid,
    );
  }
}