import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  FirebaseAuthService._();
  static FirebaseAuthService auth = FirebaseAuthService._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String?> createUsers(
      {required String email, required String password}) async {
    String message;
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      message = "Success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'operation-not-allowed':
          message = 'this service not available';
        case 'week-password':
          message = "Your password is too week";
        default:
          message = e.code;
      }
    }
    return message;
  }

  Future<String> signInUsers(
      {required String email, required String password}) async {
    String msg;
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      msg = "Success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          msg = "Invalid credential";
        case 'operation-not-allowed':
          msg = "This service no more";
        default:
          msg = e.code;
      }
    }
    return msg;
  }

  Future<User?> signInAnonymous() async {
    UserCredential userCredential = await firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  Future<String> signInGoogle() async {
    String msg;

    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        OAuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await firebaseAuth.signInWithCredential(credential);

        msg = "Success";
      } else {
        msg = "No Google Account Found";
      }
    } on FirebaseAuthException catch (e) {
      msg = e.code;
    }

    return msg;
  }

  User? get statusUser => firebaseAuth.currentUser;

  Future<void> signOutUser() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
