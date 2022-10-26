// import 'package:taxischrono/modeles/applicationuser/appliactionuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxischrono/varibles/variables.dart';

class Client {
  final String idUser;

  Client({
    required this.idUser,
    // required super.userAdresse,
    // required super.userEmail,
    // required super.userName,
    // required super.userTelephone,
    // required super.userCni,
    // super.userDescription,
    // super.motDePasse,
    // super.userid,
    // super.userProfile,
  });
  clientCollection() => firestore.collection("Clients").doc(idUser);
  Map<String, dynamic> toMap() => {
        'idUser': idUser,
      };

  saveClient() {
    clientCollection().set(toMap());
  }

  // soucrireAunPackage(ForfetsActifs forfetsActifs) async {
  //   forfetsActifsList.add(forfetsActifs.idForfait);
  //   await firestore.collection("Clients").doc(idUser).update(toMap());
  // }
}

class ForfetsActifs {
  final String idForfait;
  final int idPackage;
  DateTime activationDate;
  int nombreDeTicketsUtilise;
  int nombreDeTicketRestant;
  final String idUser;
  ForfetsActifs({
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
