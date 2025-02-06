import 'package:flutter/material.dart';
import 'package:qrmvvm/pages/home/views/home_view.dart';

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
            backgroundColor: Color(0xFF212023),
            elevation: 0,
            actionsIconTheme: IconThemeData(
              color: Colors.white,
            )),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Satoshi',
      ),
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          foregroundColor: Color(0xFF212023),
          backgroundColor: Color(0xFFEBFF57),
          child: const Icon(Icons.qr_code_scanner),
        ),
        appBar: AppBar(
          toolbarHeight: 80.0, // Increase the height of the AppBar
          title: Container(
            padding: EdgeInsets.all(10),
            child: const Text(
              "Scan QR Codes",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: Home(),
      ),
    );
  }
}
