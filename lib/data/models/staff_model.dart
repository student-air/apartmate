enum StaffRole { admin, reception, electrician, plumber, securityGuard }

extension StaffRoleX on StaffRole {
  String get label {
    switch (this) {
      case StaffRole.admin:
        return 'Admin';
      case StaffRole.reception:
        return 'Reception';
      case StaffRole.electrician:
        return 'Electrician';
      case StaffRole.plumber:
        return 'Plumber';
      case StaffRole.securityGuard:
        return 'Security Guard';
    }
  }
}

enum StaffShift { morning, evening, night }

extension StaffShiftX on StaffShift {
  String get label {
    switch (this) {
      case StaffShift.morning:
        return 'Morning (6AM – 2PM)';
      case StaffShift.evening:
        return 'Evening (2PM – 10PM)';
      case StaffShift.night:
        return 'Night (10PM – 6AM)';
    }
  }

  String get shortLabel {
    switch (this) {
      case StaffShift.morning:
        return 'Morning';
      case StaffShift.evening:
        return 'Evening';
      case StaffShift.night:
        return 'Night';
    }
  }
}

class StaffModel {
  final String id;
  final String name;
  final String phone;
  final String cnic;
  final StaffRole role;
  final StaffShift shift;
  final String? photoPath;

  const StaffModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.cnic,
    required this.role,
    required this.shift,
    this.photoPath,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    final letters = parts.take(2).map((e) => e.isNotEmpty ? e[0] : '').join();
    return letters.isEmpty ? '?' : letters.toUpperCase();
  }

  StaffModel copyWith({
    String? name,
    String? phone,
    String? cnic,
    StaffRole? role,
    StaffShift? shift,
    String? photoPath,
  }) {
    return StaffModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      cnic: cnic ?? this.cnic,
      role: role ?? this.role,
      shift: shift ?? this.shift,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}
  
