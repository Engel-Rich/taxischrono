import 'package:cloud_firestore/cloud_firestore.dart' as fst;
import 'package:taxischrono/varibles/variables.dart';

class Transaction {
  final String idTansaction;
  final String idclient;
  final String idChauffer;
  final String idReservation;
  final DateTime dateAcceptation;
  final DateTime? tempsDepart;
  final DateTime? tempsArrive;
  final DateTime? tempsAnnulation;
  final int etatTransaction;
  String? commentaireClientSurLeChauffeur;
  String? commentaireChauffeurSurLeClient;
  int? noteChauffeur;

  Transaction({
    required this.idTansaction,
    required this.idclient,
    required this.idChauffer,
    required this.idReservation,
    required this.dateAcceptation,
    required this.etatTransaction,
    this.tempsAnnulation,
    this.tempsDepart,
    this.tempsArrive,
    this.noteChauffeur,
    this.commentaireClientSurLeChauffeur,
    this.commentaireChauffeurSurLeClient,
  });

// Collection variable
  fst.DocumentReference collection() =>
      firestore.collection("Transaction").doc(idTansaction);

  // Json
  Map<String, dynamic> tomap() => {
        'idTansaction': idTansaction,
        "idClient": idclient,
        'idChauffeur': idChauffer,
        'idReservation': idReservation,
        "tempsDepart": tempsDepart,
        "tempsArrive": tempsArrive,
        "noteChauffeur": noteChauffeur,
        "commentaireClientSurLeChauffeur": commentaireClientSurLeChauffeur,
        'commentaireChauffeurSurLeClient': commentaireChauffeurSurLeClient,
        'dateAcceptation': fst.Timestamp.fromDate(dateAcceptation),
        "etatTransaction": etatTransaction,
        "tempsAnnulation": tempsAnnulation,
      };
  factory Transaction.fromJson(Map<String, dynamic> transaction) => Transaction(
        idTansaction: transaction['idTansaction'],
        idclient: transaction['idclient'],
        idChauffer: transaction['idChauffer'],
        dateAcceptation:
            (transaction['dateAcceptation'] as fst.Timestamp).toDate(),
        idReservation: transaction['idReservation'],
        tempsDepart: (transaction['tempsDepart'] as fst.Timestamp).toDate(),
        tempsArrive: (transaction['tempsArrive'] as fst.Timestamp).toDate(),
        noteChauffeur: transaction['noteChauffeur'],
        commentaireChauffeurSurLeClient:
            transaction["commentaireChauffeurSurLeClient"],
        commentaireClientSurLeChauffeur:
            transaction['commentaireClientSurLeChauffeur'],
        etatTransaction: (transaction['etatTransaction']),
        tempsAnnulation:
            (transaction['tempsAnnulation'] as fst.Timestamp).toDate(),
      );

  // Validation de la transaction
  valideTransaction() async {
    await collection().set(tomap());
  }

  noterChauffeur(int noteChauffeur) async {
    await collection().update({'noteChauffeur': noteChauffeur});
  }

  commenterSurLeClient(String comment) async {
    await collection().update({"commentaireChauffeurSurLeClient": comment});
  }

  commenterSurLaconduiteDuChauffeur(comment) async {
    await collection().update({'commentaireClientSurLeChauffeur': comment});
  }

  modifierEtat(int etat) async {
    if (etat == 2) {
      await collection().update({
        "etatTransaction": etat,
        "tempsDepart": fst.FieldValue.serverTimestamp()
      });
    } else if (etat == 1) {
      await collection().update({
        "etatTransaction": etat,
        "tempsArrive": fst.FieldValue.serverTimestamp(),
      });
    } else {
      await collection().update({
        "etatTransaction": etat,
        "tempsAnnulation": fst.FieldValue.serverTimestamp(),
      });
    }
  }
}
