import 'dart:math';

class JoinCodeGenerator {
  JoinCodeGenerator._();

  // Excludes ambiguous characters: 0/O, 1/I/L
  static const _chars = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

  static String generate() {
    final rand = Random.secure();
    String pick(int n) => List.generate(n, (_) => _chars[rand.nextInt(_chars.length)]).join();
    return '${pick(3)}-${pick(4)}';
  }
}