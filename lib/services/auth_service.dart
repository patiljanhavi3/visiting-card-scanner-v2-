import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current logged-in user
  User? get currentUser => _auth.currentUser;

  // Stream for auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up user
  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return 'The password is too weak.';
        case 'email-already-in-use':
          return 'An account already exists for this email.';
        case 'invalid-email':
          return 'Invalid email address.';
        default:
          return e.message ?? 'Signup failed. Please try again.';
      }
    } catch (_) {
      return 'An unexpected error occurred.';
    }
  }

  // Sign in user
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'user-disabled':
          return 'This account has been disabled.';
        default:
          return e.message ?? 'Login failed. Please try again.';
      }
    } catch (_) {
      return 'An unexpected error occurred.';
    }
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
