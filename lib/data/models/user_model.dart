/// Represents the signed-in society owner / user profile.
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
  });

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    final letters = parts.take(2).map((e) => e.isNotEmpty ? e[0] : '').join();
    return letters.isEmpty ? '?' : letters.toUpperCase();
  }
}