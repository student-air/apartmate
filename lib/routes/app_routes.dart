/// Central registry of route names. Never hardcode a route string
/// elsewhere in the app — always reference AppRoutes.xxx.
abstract class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const dashboard = '/dashboard';
  static const societyRegister = '/society-register';
  static const registrationStatus = '/registration-status';
  static const societyBuildings = '/society-buildings';
}
