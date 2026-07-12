// Future localization — if you ever want the app in Urdu
//  or Arabic, every string is already centralized in one file 
//  instead of buried in 14 screen files.

/// Centralized user-facing copy. Keeps text out of widgets and ready
/// for future localization (l10n) without touching UI code.
class AppStrings {
  AppStrings._();

  // App
  static const appName = 'ApartMate';
  static const appTagline = 'Management at Your Fingertips';
  static const appVersion = 'v1.0.0';

  // Auth - Login
  static const welcomeBack = 'Welcome Back';
  static const signInSubtitle = 'Sign in to manage your society';
  static const username = 'Username';
  static const usernameHint = 'Enter your username';
  static const password = 'Password';
  static const passwordHint = 'Enter your password';
  static const forgotPassword = 'Forgot Password?';
  static const login = 'Login';
  static const or = 'OR';
  static const continueWithGoogle = 'Continue with Google';
  static const continueWithApple = 'Continue with Apple';
  static const noAccount = "Don't have an account? ";
  static const signUp = 'Sign Up';

  // Auth - Signup
  static const createAccount = 'Create Account';
  static const signUpSubtitle = 'Join ApartMate as a society owner';
  static const fullName = 'Full Name';
  static const fullNameHint = 'e.g. Ahmed Khan';
  static const email = 'Email';
  static const emailHint = 'Enter your email';
  static const phoneNumber = 'Phone Number';
  static const phoneHint = '+92 300 1234567';
  static const createPasswordHint = 'Create a strong password';
  static const confirmPassword = 'Confirm Password';
  static const confirmPasswordHint = 'Re-enter your password';
  static const register = 'Register';
  static const alreadyHaveAccount = 'Already have an account? ';
}