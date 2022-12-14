import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:taxischrono/varibles/variables.dart';

class GooGleMapServices {
  // init user Location. for get User current location
  static LatLng? currentPosition;
  static requestLocation() async {
    bool serviceEnable = false;
    final permissions = await Geolocator.requestPermission();
    if (permissions != LocationPermission.denied &&
        permissions != LocationPermission.deniedForever) {
      activelocation() async => await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high)
              .then((value) async {
            currentPosition = LatLng(value.latitude, value.longitude);

            final position = await getNamePlaceFromPosition(currentPosition!);
            debugPrint("your position : $position");
          });
      serviceEnable = await Geolocator.isLocationServiceEnabled();
      if (serviceEnable) {
        activelocation();
      }
    } else {}
  }

  // request User routes.
  Future<RouteModel?> getRoute(
      {required LatLng start, required LatLng end}) async {
    // requette vers API de direction de google Map
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$mapApiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final value = jsonDecode(response.body);
      final routes = value['routes'][0];
      final legs = value['routes'][0]["legs"][0];
      RouteModel route = RouteModel(
        point: routes["overview_polyline"]["points"],
        nomDapart: legs['start_address'],
        nomArrive: legs['end_address'],
        distance: Distance.froMap(legs['distance']),
        tempsNecessaire: TempsNecessaire.froMap(legs['duration']),
      );
      return route;
    } else {
      debugPrint(response.body.toString());
    }
    return null;
  }

  // fonction pour la recherche autocomplette des ??tineraires

  static Future chekPlaceAutoComplette(
      String placeName, String sessionToken) async {
    // requette vers l'API d'autocomplette de google map
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&language=fr&key=$mapApiKey&components=country:CM";
    var listPrediction = [];
    // final requette =
    await http.get(Uri.parse(url)).then((value) {
      if (value.statusCode == 200) {
        final res = jsonDecode(value.body);
        print(res);
        if (res['status'] == 'OK') {
          final predictions = res['predictions'];

          listPrediction = (predictions as List)
              .map((place) => Place.fromJson(place))
              .toList();
          return listPrediction;
        } else {
          return 'echec';
        }
      } else {
        return 'echec';
      }
    });
    return listPrediction;
  }

// fonction permettant de r??cuperer le nom ?? partir de la position
  static Future<String> getNamePlaceFromPosition(LatLng position) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapApiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['results'][0]["formatted_address"];
    } else {
      return "echec";
    }
  }

// fonction d'obtention des informations d'otentification ?? partir d'une place.
  static Future<Adresse> checkDetailFromPlace(String placeid) async {
    Adresse? adresseRetour;
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeid&key=$mapApiKey";
    await http.get(Uri.parse(url)).then((value) {
      if (value.statusCode == 200) {
        final res = jsonDecode(value.body);
        final predictions = res['result'];
        adresseRetour = Adresse(
          adresseCode: predictions['place_id'],
          adresseName: predictions['name'],
          adresseposition: LatLng(
            predictions['geometry']['location']['lat'],
            predictions['geometry']['location']['lng'],
          ),
        );
        print("Adresse : ");
        print(adresseRetour!.toMap());
      }
    });
    return adresseRetour!;
  }

// fin de la classe des services Maps.
}

class RouteModel {
  Distance distance;
  TempsNecessaire tempsNecessaire;
  String nomDapart;
  String nomArrive;
  String point;
  RouteModel({
    required this.point,
    required this.nomDapart,
    required this.nomArrive,
    required this.distance,
    required this.tempsNecessaire,
  });

  Map<String, dynamic> toMap() => {
        "Temps ": tempsNecessaire.toMap(),
        "Distances : ": distance.toMap(),
        "Depart ": nomDapart,
        "Arrive": nomArrive,
        "Point ": point,
      };
}

class Distance {
  final String text;
  final int value;
  Distance({required this.text, required this.value});
  factory Distance.froMap(Map<String, dynamic> distance) =>
      Distance(text: distance['text'], value: distance['value']);
  Map<String, dynamic> toMap() =>
      {"Distance value": value, "Distance text": text};
}

class TempsNecessaire {
  final String text;
  final int value;
  TempsNecessaire({required this.text, required this.value});
  factory TempsNecessaire.froMap(Map<String, dynamic> distance) =>
      TempsNecessaire(text: distance['text'], value: distance['value']);

  Map<String, dynamic> toMap() => {
        'Time value': value,
        "Time Text": text,
      };
}

class Adresse {
  final LatLng adresseposition;
  final String adresseCode;

  final String adresseName;
  Adresse({
    required this.adresseCode,
    required this.adresseposition,
    required this.adresseName,
  });

  Map<String, dynamic> toMap() => {
        "Position": {
          "latitude": adresseposition.latitude,
          "longitude": adresseposition.longitude
        },
        "Code": adresseCode,
        'Nom': adresseName
      };
}

class Place {
  final String mainName;
  final String secondaryName;
  final String placeId;
  Place({
    required this.placeId,
    required this.mainName,
    required this.secondaryName,
  });

  factory Place.fromJson(Map<String, dynamic> map) => Place(
        placeId: map['place_id'],
        mainName: map['structured_formatting']['main_text'],
        secondaryName: map['structured_formatting']['secondary_text'],
      );

  Map<String, dynamic> toMap() => {
        "PlaceId": placeId,
        "Primary Name": mainName,
        "Secondary name ": secondaryName,
      };
}
