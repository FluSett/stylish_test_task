import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthenticationRepository {
  Stream<bool> isAuthenticatedChanges();

  Future<void> login({required final String email, required final String password});

  Future<void> signUp({required final String email, required final String password});

  Future<void> logout();
}

final class FirebaseAuthenticationRepository implements AuthenticationRepository {
  @override
  Stream<bool> isAuthenticatedChanges() => FirebaseAuth.instance.authStateChanges().map((final user) => user != null);

  @override
  Future<void> login({required final String email, required final String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e, _) {
      throw Exception(_getFirebaseError(e.code));
    }
  }

  @override
  Future<void> signUp({required final String email, required final String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e, _) {
      throw Exception(_getFirebaseError(e.code));
    }
  }

  @override
  Future<void> logout() async => await FirebaseAuth.instance.signOut();

  String _getFirebaseError(final String value) => switch (value) {
    'user-not-found' => 'No user found for that email.',
    'wrong-password' => 'Wrong password provided for that user.',
    _ => 'Unknow error code',
  };
}
