import 'package:taxischrono/modeles/autres/reservation.dart';
import 'package:taxischrono/modeles/autres/transaction.dart';

class Chauffeur {
  final String idUser;
  final String numeroPermi;
  final DateTime expirePermiDate;
  String profileImage;
  String idVehicule;

  Chauffeur({
    required this.idUser,
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
      idChauffer: idUser,
      idReservation: reservation.idReservation,
    );
    reservation.updateAcceptedState(true);
    transaction.valideTransaction();
  }
}
