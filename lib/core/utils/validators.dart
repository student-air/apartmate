class Validators {
  Validators._();

  /// Requires at least 8 characters and at least one special character.
  static bool isStrongPassword(String password) {
    if (password.length < 8) return false;
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(password);
    return hasSpecialChar;
  }

  static String? passwordErrorMessage(String password) {
    if (password.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(password)) {
      return 'Password must include at least one special character';
    }
    return null; // null means "valid, no error"
  }
}