import 'package:apartmate/data/models/user_model.dart';

/// Contract for authentication. Today it is backed by [LocalAuthRepository];
/// swap the binding to a Firebase-backed implementation later without
/// touching any controller or view.
abstract class IAuthRepository {
  Future<UserModel> login({required String username, required String password});
  Future<UserModel> loginWithGoogle();
  Future<UserModel> loginWithApple();
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  });
  Future<void> logout();
  UserModel? get currentUser;
}
