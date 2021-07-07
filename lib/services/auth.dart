import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign in anonymous
  Future signInAnon() async {
    try {
      var result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  //auth change user stream
  Stream get user {
    return _auth.authStateChanges();
  }

  //sign in with email & password
  Future signInEmail(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getCurrentUser() async {
    try {
      return await _auth.currentUser;
    } catch (e) {
      return null;
    }
  }

  //register with email & password
  Future register(String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await result.user!.sendEmailVerification();
      return result;
    } catch (e) {
      return null;
    }
  }

  //sign out
  void signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {}
  }
}
