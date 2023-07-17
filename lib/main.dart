import 'package:flutter/material.dart';
import 'price_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          primaryColor: const Color.fromARGB(255, 93, 101, 172),
          scaffoldBackgroundColor: const Color.fromARGB(255, 153, 168, 135)),
      home: SafeArea(child: PriceScreen()),
    );
  }
}
