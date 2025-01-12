import '../models/user.dart';

abstract class AuthService {
  Future<User?> getCurrentUser();
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(
      String email, String password, String firstName, String lastName);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Stream<User?> get authStateChanges;
}
