class Validators {
  Validators._();

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
    return null;
  }
} 