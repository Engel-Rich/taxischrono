import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:taxischrono/firebase_options.dart';

import 'package:taxischrono/screens/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: const WelcomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  // ontapField() {
  //   print('object');
  //   showMaterialModalBottomSheet(
  //       context: context,
  //       expand: true,
  //       duration: const Duration(milliseconds: 750),
  //       builder: (context) {
  //         return Container(
  //             padding: const EdgeInsets.only(top: 35, left: 20, right: 20),
  //             color: Colors.amber.shade600,
  //             child: Column(
  //               children: [
  //                 ListTile(
  //                   leading: InkWell(
  //                     onTap: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: const Icon(Icons.close, size: 30),
  //                   ),
  //                   title: const Text(
  //                     'renseignez vos positions',
  //                     style:
  //                         TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
  //                   ),
  //                   shape: RoundedRectangleBorder(
  //                       side: const BorderSide(color: Colors.white, width: 2),
  //                       borderRadius: BorderRadius.circular(20)),
  //                 )
  //               ],
  //             ));
  //       });
  // }

}
