enum RequestStatus { pending, accepted, rejected }

class RequestModel {
  final String id;
  final String buildingId;
  final String buildingName;
  final int floor;
  final String flatNumber;
  final String tenantName;
  final String phone;
  final String email;
  final int residentsCount;
  final DateTime allotmentDate;
  final double rent;
  final RequestStatus status;
  final DateTime submittedAt;

  RequestModel({
    required this.id,
    required this.buildingId,
    required this.buildingName,
    required this.floor,
    required this.flatNumber,
    required this.tenantName,
    required this.phone,
    required this.email,
    required this.residentsCount,
    required this.allotmentDate,
    required this.rent,
    required this.status,
    required this.submittedAt,
  });

  RequestModel copyWith({RequestStatus? status}) {
    return RequestModel(
      id: id,
      buildingId: buildingId,
      buildingName: buildingName,
      floor: floor,
      flatNumber: flatNumber,
      tenantName: tenantName,
      phone: phone,
      email: email,
      residentsCount: residentsCount,
      allotmentDate: allotmentDate,
      rent: rent,
      status: status ?? this.status,
      submittedAt: submittedAt,
    );
  }
}