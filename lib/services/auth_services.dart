import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class FirebaseServices {
  FirebaseServices._();
  static FirebaseServices firebaseServices = FirebaseServices._();
  FirebaseAuth auth = FirebaseAuth.instance;

  //Register with email and password
  Future<User?> register(String email, String password) async {
    User? user;
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = credential.user;
    } catch (e) {
      Logger().e('createUserWithEmailAndPassword error: $e');
    }
    return user;
  }

  //Login with email and password
  Future<User?> login(String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      Logger().e('signInWithEmailAndPassword error: $e');
      return null;
    }
  }

  //Add User With Google
  Future<User?> loginWithGoogle() async {
    GoogleSignInAccount? user = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await user?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential credentialUser = await auth.signInWithCredential(credential);
    return credentialUser.user;
  }

  //login with anonymous
  Future<User?> loginAnonymous() async {
    UserCredential credential = await auth.signInAnonymously();
    return credential.user;
  }
}
