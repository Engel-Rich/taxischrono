import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  // fonction pour la recherche autocomplette des étineraires

  static Future chekPlaceAutoComplette(
      String placeName, String sessionToken) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&language=fr&key=$mapApiKey&components=country:CM";
    var listPrediction = [];
    // final requette =
    await http.get(Uri.parse(url)).then((value) {
      if (value.statusCode == 200) {
        final res = jsonDecode(value.body);
        print(res);
        // if (res['status'] == 'OK') {
        final predictions = res['predictions'];

        listPrediction = (predictions as List)
            .map((place) => Place.fromJson(place))
            .toList();
        return listPrediction;
        // }
      } else {
        return 'echec';
      }
    });
    return listPrediction;
  }

// fonction permettant de récuperer le nom à partir de la position
  static Future<String> getNamePlaceFromPosition(LatLng position) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapApiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['results'][0]["formatted_address"];
      // final adresse = Adresse(
      //   adresseCode: body['results'][0]["address_components"][0]['long_name'],
      //   adresseposition: position,
      //   adresseCompletteCode: body['results'][0]['formatted_address'],
      //   adresseCountrieName: body['results'][6]['address_components']
      //       ['long_name'],
      //   adresseName: body['results'][0]['address_components'][5]['long_name'],
      // );
      // return adresse;
    } else {
      return "echec";
    }
  }

// fonction d'obtention des informations d'otentification à partir d'une place.
  static checkDetailFromPlace(String placeid) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeid&key=$mapApiKey";
    await http.get(Uri.parse(url)).then((value) {
      if (value.statusCode == 200) {
        final res = jsonDecode(value.body);
        if (res['status'] == "OK") {
          final predictions = res['result'];

          var adresse = Adresse(
            adresseCode: placeid,
            adresseName: predictions['name'],
            adresseposition: LatLng(predictions['geometry']['location']['lat'],
                predictions['geometry']['location']['lng']),
          );
          return adresse;
        }
      } else {
        return 'echec';
      }
    });
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
}

class Distance {
  final String text;
  final int value;
  Distance({required this.text, required this.value});
  factory Distance.froMap(Map<String, dynamic> distance) =>
      Distance(text: distance['text'], value: distance['value']);
}

class TempsNecessaire {
  final String text;
  final int value;
  TempsNecessaire({required this.text, required this.value});
  factory TempsNecessaire.froMap(Map<String, dynamic> distance) =>
      TempsNecessaire(text: distance['text'], value: distance['value']);
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
}
