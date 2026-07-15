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
  static const fullNameHint = 'e.g. John Doe';
  static const email = 'Email';
  static const emailHint = 'Enter your email';
  static const phoneNumber = 'Phone Number';
  static const phoneHint = '+923001234567';
  static const createPasswordHint = 'Create a strong password';
  static const confirmPassword = 'Confirm Password';
  static const confirmPasswordHint = 'Re-enter your password';
  static const register = 'Register';
  static const alreadyHaveAccount = 'Already have an account? ';

  // Society register
  static const registerSociety = 'Register Society';
  static const societyName = 'Society Name';
  static const societyNameHint = 'e.g. Housing Society';
  static const ownerName = 'Owner Name';
  static const ownerNameHint = 'e.g. John Doe';
  static const address = 'Address';
  static const addressHint = 'Enter the society address';
  static const city = 'City';
  static const cityHint = 'Select city';
  static const country = 'Country';
  static const countryHint = 'Select country';
  static const contactNumber = 'Contact Number';
  static const contactNumberHint = '+923001234567';
  static const descriptionOptional = 'Description (Optional)';
  static const descriptionHint = 'Brief description about the society...';
  static const submitRegistration = 'Submit Registration';
}
