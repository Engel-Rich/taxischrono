import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fst;
import 'package:taxischrono/modeles/autres/transaction.dart';
import 'package:taxischrono/varibles/variables.dart';

class Reservation {
  final String idReservation;
  final String idClient;
  Map pointDepart;
  Map pointArrive;
  Map positionClient;
  double prixReservation;
  int etatReservation;
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
    this.etatReservation = 0,
  });

// Collection

  fst.DocumentReference collection() =>
      firestore.collection("Reservation").doc(idReservation);

// Json
  Map<String, dynamic> tomap() => {
        'idReservation': idReservation,
        "pointDepart": jsonEncode(pointDepart),
        "pointArrive": jsonEncode(pointArrive),
        "positionClient": jsonEncode(positionClient),
        "prixReservation": prixReservation,
        "typeRservation": typeReservation,
        "dateReservation": fst.Timestamp.fromDate(dateReserVation),
        "etatReservation": etatReservation,
        "idClient": idClient
      };

  factory Reservation.fromJson(Map<String, dynamic> reservation) => Reservation(
      idReservation: reservation["idReservation"],
      pointDepart: jsonDecode(reservation["pointDepart"]),
      positionClient: jsonDecode(reservation["positionClient"]),
      pointArrive: jsonDecode(reservation["pointArrive"]),
      prixReservation: reservation["prixReservation"],
      dateReserVation:
          (reservation["dateReservation"] as fst.Timestamp).toDate(),
      typeReservation: reservation["typeRservation"],
      idClient: reservation['idClient'],
      etatReservation: reservation['etatReservation']);

  // validation de la réservation
  valideRservation() async {
    collection().set(tomap());
  }

  updateAcceptedState(int accept) async {
    await collection().update({"etatReservation": accept});
  }

  annuletReservation() async {
    updateAcceptedState(-1);
    // final transactions =
    await firestore.collection("Transaction").get().then((value) {
      value.docs.map((tansaction) async {
        final transaction = Transaction.fromJson(tansaction.data());
        if (transaction.idReservation == idReservation) {
          await transaction.modifierEtat(-1);
        }
      });
    });
  }
}
