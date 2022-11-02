// import 'package:taxischrono/modeles/applicationuser/chauffeur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxischrono/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischrono/modeles/applicationuser/chauffeur.dart';
import 'package:taxischrono/modeles/autres/codepromo.dart';
import 'package:taxischrono/modeles/autres/forfetclient.dart';
import 'package:taxischrono/modeles/autres/package.dart';
import 'package:taxischrono/modeles/autres/reservation.dart';
import 'package:taxischrono/modeles/autres/transaction.dart';
// import 'package:taxischrono/modeles/autres/transaction.dart';
// import 'package:taxischrono/modeles/discutions/conversation.dart';
// import 'package:taxischrono/modeles/discutions/conversation.dart';
import 'package:taxischrono/modeles/discutions/message.dart';
import 'package:taxischrono/varibles/variables.dart';

class Client extends ApplicationUser {
  // final String idUser;

  Client({
    required super.userAdresse,
    required super.userEmail,
    required super.userName,
    required super.userTelephone,
    required super.userCni,
    super.motDePasse,
    super.userDescription,
    super.userid,
    super.userProfile,
    required super.expireCniDate,
  });

  // collection variable
  DocumentReference clientCollection() =>
      firestore.collection("Clients").doc(userid);

  // serialisation
  Map<String, dynamic> toMap() => {
        'idUser': userid,
      };
  factory Client.fromMap(Map<String, dynamic> client) => Client(
        userAdresse: client["userAdresse"],
        userEmail: client["userEmail"],
        userName: client['userName'],
        userTelephone: client['userTelephone'],
        userCni: client['userCni'],
        expireCniDate: client['expireCniDate'],
        userDescription: client['userDescription'],
        userProfile: client['userProfile'],
        userid: client['userid'],
      );
// register login and vérification
  @override
  register() {
    super.register();
    clientCollection().set(toMap());
  }

  // souscrire à un code package et utiliser un code promo
  soucrireAunPackage(Packages packages, CodePromo? codePromo) {
    if (codePromo != null) {
      packages.prixPackage =
          packages.prixPackage * codePromo.pourcentageDeReduction;
    }

    // TODO implementation du payement;

    ForfetClients forfetsActifs = ForfetClients(
      idUser: userid!,
      activationDate: DateTime.now(),
      idForfait: DateTime.now().microsecondsSinceEpoch.toString(),
      nombreDeTicketRestant: packages.nombreDeTickets,
      nombreDeTicketsUtilise: 0,
      idPackage: packages.idPackage,
    );
    forfetsActifs.activerForfait();
  }

  //faire une reservations
  faireUneReservation(
      {required Map depart,
      required Map arrive,
      required Map position,
      required double prix,
      required String type}) async {
    Reservation reservation = Reservation(
      idReservation: DateTime.now().millisecondsSinceEpoch.toString(),
      idClient: userid!,
      pointDepart: depart,
      positionClient: position,
      pointArrive: arrive,
      prixReservation: prix,
      dateReserVation: DateTime.now(),
      typeReservation: type,
    );
    await reservation.valideRservation();
  }

  commenterLaCourse(
      {required TransactionApp transaction,
      required String commentaire}) async {
    transaction.commenterSurLaconduiteDuChauffeur(commentaire);
  }

  chaterAvecLeChauffeur(
      {required Chauffeur chauffeur, required String libelle}) {
    final Message message = Message(
      senderUserId: userid!,
      destinationUserId: chauffeur.userid!,
      libelle: libelle,
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      type: "chat",
      isRead: false,
    );
    envoyerUnMessage(message);
  }
}
