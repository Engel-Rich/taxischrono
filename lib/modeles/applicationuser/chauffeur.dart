import 'package:taxischrono/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischrono/modeles/autres/reservation.dart';
import 'package:taxischrono/modeles/autres/transaction.dart';
import 'package:taxischrono/varibles/variables.dart';

class Chauffeur extends ApplicationUser {
  final String numeroPermi;
  final DateTime expirePermiDate;
  String profileImage;
  String idVehicule;

  Chauffeur({
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
    required this.idVehicule,
    required this.numeroPermi,
    required this.expirePermiDate,
    required this.profileImage,
  });

  // les fonxtions de mapage du chauffeur
  // la fonction d'acceptation de la commande
  accepterLaCommande(Reservation reservation) {
    Transaction transaction = Transaction(
      idTansaction: DateTime.now().millisecondsSinceEpoch.toString(),
      idclient: reservation.idClient,
      dateAcceptation: DateTime.now(),
      idChauffer: userid!,
      idReservation: reservation.idReservation,
      etatTransaction: 0,
    );
    reservation.updateAcceptedState(1);
    transaction.valideTransaction();
  }

  // Stream<Chauffeur> appUserInfos(idClient) {
  //   return firestore
  //       .collection('Utilisateur')
  //       .doc(idClient)
  //       .snapshots()
  //       .map((user) {
  //     final appUser = ApplicationUser.fromJson(user.data()!);
  //     firestore
  //         .collection('Chauffeur')
  //         .doc(idClient)
  //         .snapshots()
  //         .map((event) {});
  //   });
  // }
}
