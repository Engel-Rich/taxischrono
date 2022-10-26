import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:taxischrono/varibles/variables.dart';

class Authservices extends ChangeNotifier {
  GoogleSignInAccount? account;
  googlesingIn() async {
    final usergoogle = await googleSignIn.signIn();
    if (usergoogle == null) {
      return null;
    }
    try {
      account = usergoogle;

      final authUser = await account!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: authUser.accessToken,
        idToken: authUser.idToken,
      );
      await authentication.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
    }
    notifyListeners();
  }

  singInAppl() async {
    if (!await TheAppleSignIn.isAvailable()) {
      return 'l\'authentification avec apple n\'est pas disponible sur votre mobile';
    }
    try {
      final AuthorizationResult result = await TheAppleSignIn.performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          final AppleIdCredential credentialId = result.credential!;
          final OAuthProvider authProvider = OAuthProvider("apple.com");
          final credential = authProvider.credential(
              idToken: String.fromCharCodes(credentialId.identityToken!),
              accessToken:
                  String.fromCharCodes(credentialId.authorizationCode!));
          await authentication.signInWithCredential(credential);
          break;
        case AuthorizationStatus.error:
          return "pas d'authorisation";
        case AuthorizationStatus.cancelled:
          return "requette Annulée";
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
    }

    notifyListeners();
  }

// flutter register whit Email and Password
  register(email, password) async {
    // final secondary = Firebase.app("secondaryApp");
    // final auth = FirebaseAuth.instanceFor(app: secondary);
    try {
      final util = await authentication.createUserWithEmailAndPassword(
          email: email, password: password);
      if (util.user != null) {
        // final actioncodeSettigns = ActionCodeSettings(
        //   url: 'https://www.incc.taxischrono.app/?email=${util.user!.email}',
        //   androidPackageName: "com.incc.taxischrono.app",
        //   iOSBundleId: "com.incc.taxischrono.app",
        //   androidInstallApp: true,
        //   handleCodeInApp: true,
        // );
        await util.user!.sendEmailVerification();
      } else {
        return "register Error";
      }
    } on FirebaseAuthException catch (e) {
      return e.code;
    } on Exception catch (e) {
      return e.toString();
    }
  }

// flutter logOUt
  login(email, password) async {
    try {
      await authentication.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

// flutter Login
  logOut() async {
    try {
      await googleSignIn.disconnect();
      await authentication.signOut();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
    }
  }
}
