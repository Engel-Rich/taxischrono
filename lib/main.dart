import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:taxischrono/varibles/variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TaxisChrono',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TaxisChronoStartApp());
  }
}

class TaxisChronoStartApp extends StatefulWidget {
  const TaxisChronoStartApp({super.key});

  @override
  State<TaxisChronoStartApp> createState() => _TaxisChronoStartAppState();
}

class _TaxisChronoStartAppState extends State<TaxisChronoStartApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.menu),
      //     onPressed: () {},
      //   ),
      // ),
      drawer: Container(
        width: taille(context).width * 0.75,
        color: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(3.844119, 11.501346),
                zoom: 14,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: taille(context).width * 0.05, vertical: 20),
              padding: const EdgeInsets.all(15),
              constraints: const BoxConstraints(maxHeight: 150),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: ontapField,
                    child: TextFormField(
                      readOnly: true,
                      enabled: false,
                      decoration: InputDecoration(
                          hintText: "Ou Allons nous",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ontapField() {
    print('object');
    showMaterialModalBottomSheet(
        context: context,
        expand: true,
        duration: const Duration(milliseconds: 750),
        builder: (context) {
          return Container(
              padding: const EdgeInsets.only(top: 35, left: 20, right: 20),
              color: Colors.amber.shade600,
              child: Column(
                children: [
                  ListTile(
                    leading: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.close, size: 30),
                    ),
                    title: const Text(
                      'renseignez vos positions',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(20)),
                  )
                ],
              ));
        });
  }
}
