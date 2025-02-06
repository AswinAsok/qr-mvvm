import 'package:flutter/material.dart';

class QRScannerCorner extends StatelessWidget {
  const QRScannerCorner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          left: BorderSide(width: 3, color: Colors.black),
          top: BorderSide(width: 3, color: Colors.black),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
        ),
      ),
    );
  }
}
