import 'package:taxischrono/modeles/autres/reservation.dart';
import 'package:taxischrono/varibles/variables.dart';

class Transaction {
  final String idTansaction;
  final String idclient;
  final String idChauffer;
  final String idReservation;
  final DateTime? tempsDepart;
  final DateTime? tempsArrive;
  String? commentaireClient;
  String? commentaireChauffeur;
  int? noteChauffeur;

  Transaction({
    required this.idTansaction,
    required this.idclient,
    required this.idChauffer,
    required this.idReservation,
    this.tempsDepart,
    this.tempsArrive,
    this.noteChauffeur,
    this.commentaireClient,
    this.commentaireChauffeur,
  });

  Map<String, dynamic> tomap() => {
        'idTansaction': idTansaction,
        "idClient": idclient,
        'idChauffeur': idChauffer,
        'idReservation': idReservation,
        "tempsDepart": tempsDepart,
        "tempsArrive": tempsArrive,
        "noteChauffeur": noteChauffeur,
        "commentaireClient": commentaireClient,
        'commentaireChauffeur': commentaireChauffeur,
      };
  factory Transaction.fromJson(Map<String, dynamic> transaction) => Transaction(
        idTansaction: transaction['idTansaction'],
        idclient: transaction['idclient'],
        idChauffer: transaction['idChauffer'],
        idReservation: transaction['idReservation'],
        tempsDepart: transaction['tempsDepart'],
        tempsArrive: transaction['tempsArrive'],
        noteChauffeur: transaction['noteChauffeur'],
        commentaireChauffeur: transaction["commentaireChauffeur"],
        commentaireClient: transaction['commentaireClient'],
      );

  // Validation de la transaction
  valideTransaction() async {
    await firestore.collection("Transaction").doc(idTansaction).set(tomap());
  }
}
