// import 'package:taxischrono/modeles/applicationuser/chauffeur.dart';
import 'package:taxischrono/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischrono/modeles/applicationuser/chauffeur.dart';
import 'package:taxischrono/modeles/autres/codepromo.dart';
import 'package:taxischrono/modeles/autres/forfetclient.dart';
import 'package:taxischrono/modeles/autres/package.dart';
import 'package:taxischrono/modeles/autres/reservation.dart';
import 'package:taxischrono/modeles/autres/transaction.dart';
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
  clientCollection() => firestore.collection("Clients").doc(userid);

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

  annulerUneRservation(Reservation reservation) async {
    await reservation.annuletReservation();
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

  singalerUrgence({required String message}) {
    final Message msg = Message(
      senderUserId: userid!,
      destinationUserId: idServiceClient,
      libelle: message,
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'urgence',
      isRead: false,
    );
    Message reponse = Message(
      senderUserId: idServiceClient,
      destinationUserId: userid!,
      libelle:
          "Merci de bien vouloir nous signaler votre urgence S'il-vous-plait",
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'reponse',
      isRead: false,
    );
    envoyerUnMessage(msg);
    envoyerUnMessage(reponse);
  }

  contacterLeServiceClient({required String message}) {
    final Message msg = Message(
      senderUserId: userid!,
      destinationUserId: idServiceClient,
      libelle: message,
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'contacter',
      isRead: false,
    );
    envoyerUnMessage(msg);
  }

  signalerDepart({required Transaction transaction}) {
    transaction.modifierEtat(2);
  }

  signalerArriver({required Transaction transaction}) {
    transaction.modifierEtat(1);
  }

  noterLechauffeur({required Transaction transaction, required int note}) {
    transaction.noterChauffeur(note);
  }

  commenterLaCourse(
      {required Transaction transaction, required String commentaire}) async {
    transaction.commenterSurLaconduiteDuChauffeur(commentaire);
  }
}
