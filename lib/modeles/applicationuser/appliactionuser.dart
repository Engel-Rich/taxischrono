import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taxischrono/services/firebaseauthservice.dart';
import 'package:taxischrono/varibles/variables.dart';

class ApplicationUser {
  final String? userid;
  final String userEmail;
  final String userName;
  final String userTelephone;
  final String? userProfile;
  final String? motDePasse;
  final String userAdresse;
  final String? userDescription;
  final String userCni;

  ApplicationUser({
    required this.userAdresse,
    required this.userEmail,
    required this.userName,
    required this.userTelephone,
    required this.userCni,
    this.motDePasse,
    this.userDescription,
    this.userid,
    this.userProfile,
  });

  factory ApplicationUser.fromJson(Map<String, dynamic> mapUser) =>
      ApplicationUser(
        userAdresse: mapUser['userAdresse'],
        userEmail: mapUser['userEmail'],
        userName: mapUser['userName'],
        userTelephone: mapUser['userTelephone'],
        userCni: mapUser['userCni'],
        userDescription: mapUser['userDescription'],
        userid: mapUser['userid'],
        userProfile: mapUser['userProfile'],
      );

  Map<String, dynamic> toJson() => {
        'userAdresse': userAdresse,
        'userEmail': userEmail,
        'userName': userName,
        'userTelephone': userTelephone,
        'userCni': userCni,
        'userDescription': userDescription,
        'userid': userid,
        'userProfile': userProfile,
      };

  saveUser() async {
    final doc = await firestore.collection('Utilisateur').doc(userid!).get();
    if (doc.exists) {
      await firestore.collection('Utilisateur').doc(userid!).update(toJson());
    } else {
      await firestore.collection('Utilisateur').doc(userid!).set(toJson());
    }
  }

  login() {
    if (authentication.currentUser == null) {
      Authservices().login(userEmail, motDePasse);
    }
  }

  register() async {
    String error = "";
    if (authentication.currentUser == null) {
      Authservices().register(userEmail, motDePasse);
    }
    if (authentication.currentUser != null) {
      final user = authentication.currentUser!;
      await authentication.verifyPhoneNumber(
        timeout: const Duration(seconds: 90),
        phoneNumber: userTelephone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await user.updatePhoneNumber(credential).then((value) {
            saveUser();
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          error = exception.code;
          debugPrint(error);
        },
        codeSent: (String verificationId, int? resentokent) async {
          // notons que la variable smsCode sera modifier par lor de la connexion à
          //l'interface utilisateur

          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);
          await authentication.currentUser!
              .updatePhoneNumber(credential)
              .then((value) {
            saveUser();
          });
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    }
  }
}
