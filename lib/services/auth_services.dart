import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Private Named Constructor
  AuthService._();

  // Singleton Object
  static AuthService authService = AuthService._();

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  // Todo: User Register Method
  Future<String> registerUser({
    required String email,
    required String password,
  }) async {
    String msg;
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      msg = "Success";
    } on FirebaseAuthException catch (e) {
      log("Sign Up : ${e.code}");
      switch (e.code) {
        case 'operation-not-allowed':
          msg = 'try another way to login';
        case 'week-password':
          msg = "password is week 🔒";
        case 'email-already-in-use':
          msg = "email already exits...";
        default:
          msg = e.code;
      }
    }

    return msg;
  }

  // Todo: User Login Method
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String msg;
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      msg = "Success";
    } on FirebaseAuthException catch (e) {
      log("Exception : ${e.code}");

      switch (e.code) {
        case 'invalid-credential':
          msg = "email or password is invalid";
        case 'operation-not-allowed':
          msg = 'try another way to login';
        default:
          msg = e.code;
      }
    }

    return msg;
  }

// Todo: Login With Google Method
  Future<String> loginWithGoogle() async {
    String msg;
    try {
      GoogleSignInAccount? googleUsers = await googleSignIn.signIn();

      if (googleUsers != null) {
        GoogleSignInAuthentication googleAuth =
            await googleUsers.authentication;

        var credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await auth.signInWithCredential(credential);

        msg = "Success";
      } else {
        msg = "Not Google Account !!!";
      }
    } on FirebaseAuthException catch (e) {
      msg = e.code;
    }
    return msg;
  }

// Todo: LogOut Method
  Future<void> logOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }

// Get Current User
  User? get currentUser => auth.currentUser;
}
