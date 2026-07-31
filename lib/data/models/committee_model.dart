class CommitteeMemberModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String role; // e.g. President, Secretary, Member

  const CommitteeMemberModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    final letters = parts.take(2).map((e) => e.isNotEmpty ? e[0] : '').join();
    return letters.isEmpty ? '?' : letters.toUpperCase();
  }
}