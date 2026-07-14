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
}
