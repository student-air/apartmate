class ResidentModel {
  final String id;
  final String buildingId;
  final String buildingName;
  final int floor;
  final String flatNumber;
  final String name;
  final String phone;
  final String email;
  final int residentsCount;
  final DateTime allotmentDate;
  final double rent;

  const ResidentModel({
    required this.id,
    required this.buildingId,
    required this.buildingName,
    required this.floor,
    required this.flatNumber,
    required this.name,
    required this.phone,
    required this.email,
    required this.residentsCount,
    required this.allotmentDate,
    required this.rent,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    final letters = parts.take(2).map((e) => e.isNotEmpty ? e[0] : '').join();
    return letters.isEmpty ? '?' : letters.toUpperCase();
  }
}