import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxischrono/varibles/variables.dart';

class Reservation {
  final String idReservation;
  final String idClient;
  Map pointDepart;
  Map pointArrive;
  Map positionClient;
  double prixReservation;
  bool accepted;
  DateTime dateReserVation;
  String typeReservation;

  Reservation({
    required this.idReservation,
    required this.idClient,
    required this.pointDepart,
    required this.positionClient,
    required this.pointArrive,
    required this.prixReservation,
    required this.dateReserVation,
    required this.typeReservation,
    this.accepted = false,
  });

  Map<String, dynamic> tomap() => {
        'idReservation': idReservation,
        "pointDepart": jsonEncode(pointDepart),
        "pointArrive": jsonEncode(pointArrive),
        "positionClient": jsonEncode(positionClient),
        "prixReservation": prixReservation,
        "typeRservation": typeReservation,
        "dateReservation": dateReserVation,
        "accepted": accepted,
        "idClient": idClient
      };

  factory Reservation.fromJson(Map<String, dynamic> reservation) => Reservation(
      idReservation: reservation["idReservation"],
      pointDepart: reservation["pointDepart"],
      positionClient: reservation["positionClient"],
      pointArrive: reservation["pointArrive"],
      prixReservation: reservation["prixReservation"],
      dateReserVation: reservation["dateReservation"],
      typeReservation: reservation["typeRservation"],
      idClient: reservation['idClient'],
      accepted: reservation['accepted']);

  // validation de la réservation
  valideRservation() async {
    firestore.collection("Reservation").doc(idReservation).set(tomap());
  }

  updateAcceptedState(bool accept) async {
    await firestore
        .collection("Reservation")
        .doc(idReservation)
        .update({"accepted": accept});
  }
}
