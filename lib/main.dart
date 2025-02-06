import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            actionsIconTheme: IconThemeData(
              color: Colors.white,
            )),
        fontFamily: 'Satoshi',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Scan QR Codes",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: const Scaffold(),
      ),
    );
  }
}
