import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:taxischrono/varibles/variables.dart';

class GooGleMapServices extends GetxController {
  // init user Location. for get User current location
  static var currentPosition = const LatLng(3.866667, 11.516667).obs;
  static requestLocation() async {
    bool serviceEnable = false;
    activelocation() async => await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high)
            .then((value) async {
          currentPosition.value = LatLng(value.latitude, value.longitude);

          final position =
              await getNamePlaceFromPosition(currentPosition.value);
          debugPrint("your position : $position");
        });
    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (serviceEnable) {
      activelocation();
    } else {
      final permissions = await Geolocator.requestPermission();
      if (permissions != LocationPermission.denied &&
          permissions != LocationPermission.deniedForever) {
        activelocation();
      }
    }
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

// fonction permettant de récuperer le nom à partir de la position
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
