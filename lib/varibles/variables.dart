import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

// google signin variable;

final googleSignIn = GoogleSignIn();
const dredColor = Color.fromARGB(248, 255, 233, 33);
// firebase variables

final authentication = FirebaseAuth.instance;
final datatbase = FirebaseDatabase.instance;
final firestore = FirebaseFirestore.instance;

final police = GoogleFonts.poppins(fontSize: 14);
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

const mapApiKey = "AIzaSyDRiuLYKs1ymgiW97p3ybAuQLOQcBDqUvg";
const younde = LatLng(3.866667, 11.516667);
const String idServiceClient = "taxisChronoInccCenter";

// les fonctions

Size taille(BuildContext context) => MediaQuery.of(context).size;

// adresse de la console google : https://console.cloud.google.com
