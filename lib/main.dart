import 'package:flutter/material.dart';
import 'package:taxischrono/welcome_page.dart';

const d_red = Color.fromARGB(248, 255, 233, 33);
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Taxis CHRONO',
        debugShowCheckedModeBanner: false,
        home: WelcomePage());
  }
}
