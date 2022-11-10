import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:taxischrono/services/mapservice.dart';

import 'package:taxischrono/varibles/variables.dart';

class MapReservation extends StatefulWidget {
  final Adresse adressestart, adresseend;
  final RouteModel routeModel;
  const MapReservation({
    super.key,
    required this.adressestart,
    required this.adresseend,
    required this.routeModel,
  });

  @override
  State<MapReservation> createState() => _MapReservationState();
}

class _MapReservationState extends State<MapReservation> {
  ///////////////////
  // les variables
  ///////////////.

  Completer<GoogleMapController> controllerMap =
      Completer<GoogleMapController>();

  String destination = '';
  PolylinePoints polylinePoints = PolylinePoints();

  // final scaffoldKey = GlobalKey<ScaffoldState>();

  bool voirs = false;
  Map<PolylineId, Polyline> polylinesSets = {};
  Set<Marker> markersSets = {};

  // la finction de démarage.
  @override
  void initState() {
    getLines();
    markermecker();
    // GooGleMapServices.requestLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            SlidingUpPanel(
                parallaxEnabled: true,
                minHeight: taille(context).height * 0.17,
                maxHeight: taille(context).height * 0.30,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                body: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.adressestart.adresseposition,
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    setState(() {
                      controllerMap.complete(controller);
                    });
                  },
                  markers: markersSets,
                  polylines: Set<Polyline>.of(polylinesSets.values),
                ),
                panelBuilder: (controller) {
                  return SafeArea(
                    child: ListView(
                      controller: controller,
                      children: [
                        Center(
                          child: SizedBox(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 10,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        boutonText(
                            context: context,
                            text: 'Valider la commande',
                            action: () {})
                      ],
                    ),
                  );
                }),
            Positioned(
              top: 10,
              left: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: const CircleAvatar(
                        child: FaIcon(
                          Icons.close,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  ///////////////////
  ///les fonctions
  ///////////////.

// creation  de la ligne

  getLines() async {
    // PolylineResult polylineResult =
    List<LatLng> polylineCoordinates = [];
    await polylinePoints
        .getRouteBetweenCoordinates(
      mapApiKey,
      PointLatLng(
        widget.adressestart.adresseposition.latitude,
        widget.adressestart.adresseposition.longitude,
      ),
      PointLatLng(
        widget.adresseend.adresseposition.latitude,
        widget.adresseend.adresseposition.longitude,
      ),
      travelMode: TravelMode.driving,
    )
        .then(
      (value) {
        if (value.points.isNotEmpty) {
          for (var element in value.points) {
            polylineCoordinates
                .add(LatLng(element.latitude, element.longitude));
          }
        } else {
          debugPrint(value.errorMessage);
        }
        addpolylinespoints(polylineCoordinates);
      },
    );
  }

  // addpolylinespoins permet de récupérer une liste de latlng et ajouter aux poins.

  addpolylinespoints(List<LatLng> listlatlng) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: listlatlng,
      color: vert,
      width: 5,
    );
    polylinesSets[id] = polyline;
  }

// mettre à jour la liste des markers

  markermecker() {
    final debut = widget.adressestart;
    final fin = widget.adresseend;

    // ajout du point de départ
    markersSets.add(
      Marker(
        markerId: MarkerId(debut.adresseCode),
        position: debut.adresseposition,
        infoWindow: InfoWindow(
          title: debut.adresseName,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    // Ajout du point d'arrivé
    markersSets.add(
      Marker(
        markerId: MarkerId(fin.adresseCode),
        position: fin.adresseposition,
        infoWindow: InfoWindow(
          title: fin.adresseName,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
  }

  // fin de la fontion principale
}