import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qrmvvm/pages/qrgenerator.dart/generator_view.dart';
import 'package:qrmvvm/pages/qrscanner/scanner_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => ScannerView(),
      ),
      GoRoute(
        path: '/generator',
        builder: (context, state) => GeneratorView(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'QR MVVM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
