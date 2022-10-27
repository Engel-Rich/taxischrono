import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(),
      drawer: Container(
        width: taille(context).width * 0.75,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
