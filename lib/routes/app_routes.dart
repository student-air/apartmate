/// Central registry of route names. Never hardcode a route string
/// elsewhere in the app — always reference AppRoutes.xxx.
abstract class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const signupHandoff = '/signup-handoff';
  static const societyRegister = '/society-register';
  static const registrationStatus = '/registration-status';
  static const societyBuildings = '/society-buildings';
  static const buildingDetail = '/building-detail';
  static const managementStaff = '/management-staff';  
  //static const notices = '/notices';
  //static const sendNotice = '/send-notice';
  //static const requests = '/requests';
  //static const profile = '/profile';
  static const dashboard = '/dashboard';
  static const sendNotice = '/send-notice';
  static const notices = '/notices';
  static const requests = '/requests';
  static const profile = '/profile';
}
