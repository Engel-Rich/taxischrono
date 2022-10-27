import 'package:cloud_firestore/cloud_firestore.dart';

import '../../varibles/variables.dart';

class ForfetClients {
  final String idForfait;
  final int idPackage;
  DateTime activationDate;
  int nombreDeTicketsUtilise;
  int nombreDeTicketRestant;
  final String idUser;
  ForfetClients({
    required this.idUser,
    required this.activationDate,
    required this.idForfait,
    required this.nombreDeTicketRestant,
    required this.nombreDeTicketsUtilise,
    required this.idPackage,
  });

  Map<String, dynamic> toMap() => {
        "idForfait": idForfait,
        "idPackage": idPackage,
        "activationDate": Timestamp.fromDate(activationDate),
        "nombreDeTicketsUtilise": nombreDeTicketsUtilise,
        "nombreDeTicketRestant": nombreDeTicketRestant,
      };
  forfetCollection() => firestore
      .collection('Client')
      .doc(idUser)
      .collection("ForfetsActifs")
      .doc(idForfait);
  activerForfait() async {
    await forfetCollection().set(toMap());
  }

  utiliserUnTicket() async {
    nombreDeTicketsUtilise++;
    nombreDeTicketRestant -= 1;
    if (nombreDeTicketRestant > 0) {
      await forfetCollection().update(toMap());
    } else {
      await forfetCollection().delete();
    }
  }
}
