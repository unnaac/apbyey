import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String nik,
    required String phone,
    required String username,
  }) async {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user != null) {
      await _database.child("users/${user.uid}").set({
        "uid": user.uid,
        "nik": nik,
        "phone": phone,
        "email": email,
        "username": username,
        "createdAt": DateTime.now().toIso8601String(),
      });
    }

    return user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
