import 'dart:async';

import "package:flutter/material.dart";
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

  Completer controllerMap = Completer<GoogleMapController>();

  String destination = '';
  // final scaffoldKey = GlobalKey<ScaffoldState>();
  bool voirs = false;
  Set<Polyline> polulinesSets = {};
  Set<Marker> markersSets = {};
  @override
  void initState() {
    GooGleMapServices.requestLocation();
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
                      target: GooGleMapServices.currentPosition ?? younde,
                      zoom: 12),
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

  // fin de la fontion principale
}
