import 'dart:async';

import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  bool expended = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const GoogleMap(
              initialCameraPosition: CameraPosition(target: younde, zoom: 14),
            ),
            Positioned(
              child: DraggableScrollableSheet(
                minChildSize: taille(context).height * 0.1,
                expand: expended,
                builder: (context, controller) {
                  return Column(
                    children: [
                      TextFormField(
                        onTap: () {},
                        style: police,
                        decoration: InputDecoration(
                          hintText: "ou allons nous",
                          hintStyle: police,
                          filled: true,
                          fillColor: Colors.grey.shade200.withOpacity(0.7),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
