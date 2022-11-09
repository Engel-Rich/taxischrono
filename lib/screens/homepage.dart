import 'dart:async';

import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:page_transition/page_transition.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:taxischrono/screens/etineraires.dart';
import 'package:taxischrono/services/mapservice.dart';

import 'package:taxischrono/varibles/variables.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///////////////////
  ///les variables
  ///////////////.
  Completer controllerMap = Completer<GoogleMapController>();
  ScrollController controllerSlide = ScrollController();
  TextEditingController controllerdest = TextEditingController();
  String destination = '';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool voirs = false;

  ///////////////////
  ///les fonctions
  ///////////////.
  @override
  void initState() {
    GooGleMapServices.requestLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: SafeArea(
        child: Container(
          color: vert,
          margin: EdgeInsets.only(right: taille(context).width * 0.2),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SlidingUpPanel(
                parallaxEnabled: true,
                minHeight: taille(context).height * 0.17,
                maxHeight: taille(context).height * 0.35,
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
                            text: 'Ou Allons nous',
                            action: () {
                              Navigator.of(context).push(PageTransition(
                                  child: const SearchDestinaitionPage(),
                                  type: PageTransitionType.bottomToTop));
                            })
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
                      onTap: () {
                        scaffoldKey.currentState!.openDrawer();
                      },
                      child: const FaIcon(
                        Icons.menu,
                        size: 30,
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
}



// le diviseur

