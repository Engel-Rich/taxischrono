import 'package:taxischrono/modeles/autres/codepromo.dart';
import 'package:taxischrono/modeles/autres/forfetclient.dart';
import 'package:taxischrono/modeles/autres/package.dart';
import 'package:taxischrono/modeles/autres/reservation.dart';
import 'package:taxischrono/varibles/variables.dart';

class Client {
  final String idUser;

  Client({
    required this.idUser,
  });
  clientCollection() => firestore.collection("Clients").doc(idUser);
  Map<String, dynamic> toMap() => {
        'idUser': idUser,
      };

// register login and vérification
  saveClient() {
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
      idUser: idUser,
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
      Map depart, Map arrive, Map position, double prix, String type) {
    Reservation reservation = Reservation(
      idReservation: DateTime.now().millisecondsSinceEpoch.toString(),
      idClient: idUser,
      pointDepart: depart,
      positionClient: position,
      pointArrive: arrive,
      prixReservation: prix,
      dateReserVation: DateTime.now(),
      typeReservation: type,
    );
    reservation.valideRservation();
  }
}
