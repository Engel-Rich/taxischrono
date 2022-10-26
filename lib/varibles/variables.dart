import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authentication = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();
final datatbase = FirebaseDatabase.instance;
final firestore = FirebaseFirestore.instance;
// les variables pour l'OTP
var smsCode = "";
var resend = false;
