import 'dart:async';

import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
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
      body: SafeArea(
        child: SlidingUpPanel(
            color: vert,
            parallaxEnabled: true,
            minHeight: taille(context).height * 0.17,
            maxHeight: taille(context).height * 0.95,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                              color: blanc,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ),
                    TextFormField(
                      onTap: () {
                        setState(() {
                          voirs = true;
                        });
                      },
                      onChanged: (val) {
                        if (destination.trim() != val.trim() &&
                            val.isNotEmpty) {
                          setState(() => destination = val);
                        }
                      },
                      style: police,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        hintText: "ou allons nous",
                        hintStyle: police,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: blanc),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        fillColor: Colors.grey.shade200.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    voirs
                        ? SizedBox(
                            height: taille(context).height * 0.8,
                            width: double.infinity,
                            child: FutureBuilder(
                                future:
                                    GooGleMapServices.chekPlaceAutoComplette(
                                        destination, "device"),
                                builder: (context, snappshot) {
                                  if (snappshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child:
                                                CircularProgressIndicator()));
                                  } else {
                                    if (snappshot.connectionState ==
                                        ConnectionState.none) {
                                      return Center(
                                          child: Text(
                                        'Echec de connexion à internet',
                                        style: police,
                                      ));
                                    } else {
                                      if (snappshot.data == "echec") {
                                        return Text(snappshot.error.toString());
                                      } else {
                                        return snappshot.data == null
                                            ? Center(
                                                child: Text(
                                                'OU Allons nous',
                                                style: police.copyWith(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 20,
                                                    letterSpacing: 3),
                                              ))
                                            : ListView.separated(
                                                itemCount:
                                                    (snappshot.data as List)
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  final data = snappshot.data
                                                      as List<Place>;
                                                  return ListTile(
                                                    title: Text(
                                                        data[index].mainName,
                                                        style: police),
                                                    subtitle: Text(
                                                        data[index]
                                                            .secondaryName,
                                                        style: police),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Divider(
                                                      color: blanc,
                                                    ),
                                                  );
                                                },
                                              );
                                      }
                                    }
                                  }
                                }),
                          )
                        : Container()
                  ],
                ),
              );
            }),
      ),
    );
  }
}
