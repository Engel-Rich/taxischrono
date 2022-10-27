import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// google signin variable;

final googleSignIn = GoogleSignIn();

// firebase variables

final authentication = FirebaseAuth.instance;
final datatbase = FirebaseDatabase.instance;
final firestore = FirebaseFirestore.instance;

// les variables pour l'OTP
var smsCode = "";
// const
const etatReservation = {0: "en attente", 1: "accepté", -1: "Annuleé"};
const etatTransaction = {
  0: 'initier',
  1: "terminer",
  -1: "Annulé",
  2: "en cours"
};

const String idServiceClient = "taxisChronoInccCenter";

// les fonctions

Size taille(BuildContext context) => MediaQuery.of(context).size;
