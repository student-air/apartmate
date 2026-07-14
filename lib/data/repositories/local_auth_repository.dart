import 'package:apartmate/data/models/user_model.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';

/// In-memory stand-in for a real backend. Simulates network latency so the
/// UI/loading-state behaviour matches what a real API integration will feel
/// like. Replace with a FirebaseAuthRepository later — same interface,
/// zero UI changes required.
class LocalAuthRepository implements IAuthRepository {
  UserModel? _currentUser;

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Future<UserModel> login({required String username, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _currentUser = const UserModel(
      id: 'u-1',
      fullName: 'Ahmed Khan',
      email: 'ahmed.khan@example.com',
      phone: '+92 321 1234567',
      role: 'Society Owner',
    );
    return _currentUser!;
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 700));
    _currentUser = const UserModel(
      id: 'u-1',
      fullName: 'Ahmed Khan',
      email: 'ahmed.khan@example.com',
      phone: '+92 321 1234567',
      role: 'Society Owner',
    );
    return _currentUser!;
  }

  @override
  Future<UserModel> loginWithApple() => loginWithGoogle();

  @override
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _currentUser = UserModel(
      id: 'u-1',
      fullName: fullName,
      email: email,
      phone: phone,
      role: 'Society Owner',
    );
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }
}
