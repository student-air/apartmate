import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apartmate/data/models/user_model.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';

class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  UserModel? _cached;
  bool _googleInitialized = false;

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    await _googleSignIn.initialize();
    _googleInitialized = true;
  }

  @override
  UserModel? get currentUser {
    final u = _auth.currentUser;
    if (u == null) return null;
    return _cached ?? _map(u);
  }

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: username.trim(),
      password: password,
    );
    final user = cred.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user returned from Firebase',
      );
    }
    _cached = _map(user);
    return _cached!;
  }

  @override
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = cred.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user returned from Firebase',
      );
    }

    await user.updateDisplayName(fullName.trim());
    await user.reload();

    _cached = UserModel(
      id: user.uid,
      fullName: fullName.trim(),
      email: user.email ?? email.trim(),
      phone: phone.trim(),
      role: 'Society Owner',
    );
    return _cached!;
  }

  @override
  Future<UserModel> updateProfile(UserModel updated) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Not signed in');
    await user.updateDisplayName(updated.fullName);
    await user.reload();
    _cached = updated;
    return updated;
  }

  @override
  Future<void> logout() async {
    try {
      await _ensureGoogleInitialized();
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
    _cached = null;
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    await _ensureGoogleInitialized();

    final GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );
    } on GoogleSignInException catch (e) {
      // User cancelled the picker
      if (e.code.name.contains('canceled') ||
          e.code.name.contains('cancelled') ||
          e.code.name.contains('interrupted')) {
        throw FirebaseAuthException(
          code: 'aborted-by-user',
          message: 'Google sign-in was cancelled',
        );
      }
      rethrow;
    }

    final googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'missing-id-token',
        message: 'Google sign-in did not return an ID token',
      );
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user returned from Google sign-in',
      );
    }

    _cached = _map(user);
    return _cached!;
  }

  @override
  Future<UserModel> loginWithApple() async {
    throw UnimplementedError('Apple sign-in will be added later');
  }

  UserModel _map(User user) {
    return UserModel(
      id: user.uid,
      fullName: user.displayName ?? '',
      email: user.email ?? '',
      phone: user.phoneNumber ?? _cached?.phone ?? '',
      role: 'Society Owner',
      photoPath: user.photoURL,
    );
  }
}