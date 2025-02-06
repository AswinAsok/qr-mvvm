import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrmvvm/pages/qrscanner/widgets/qr_scanner_corner.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 425,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: Stack(
                              children: [
                                QRScannerCorner(),
                                Positioned(
                                  right: 0,
                                  child: Transform.rotate(
                                    angle: Math.pi / 2,
                                    child: QRScannerCorner(),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Transform.rotate(
                                    angle: Math.pi,
                                    child: QRScannerCorner(),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Transform.rotate(
                                    angle: -Math.pi / 2,
                                    child: QRScannerCorner(),
                                  ),
                                ),
                                Center(
                                    child: Column(
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.touch_app,
                                          color: Colors.black,
                                          size: 40,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Tap to Scan",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 175,
                                      height: 175,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: MobileScanner(
                                          onDetect: (capture) {},
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Place a QR code inside the frame to scan it",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}

class Math {
  static double pi = 3.1415926535897932;
}
