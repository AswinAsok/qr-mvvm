import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qrmvvm/pages/qrscanner/viewmodels/scanner_view_models.dart';
import 'package:qrmvvm/pages/qrscanner/widgets/qr_scanner_corner.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScannerViewModel(),
      child: Consumer<ScannerViewModel>(builder: (context, viewModel, child) {
        return Scaffold(
            body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Scanner(viewModel: viewModel),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Scan Result',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 24,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Txt",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black54,
                                ),
                                onPressed: () {},
                                icon: Icon(Icons.copy, color: Colors.white),
                                label: Text("Copy",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black54,
                                ),
                                onPressed: () async {},
                                icon: Icon(Icons.open_in_browser,
                                    color: Colors.white),
                                label: Text("Open in Browser",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black54,
                                ),
                                onPressed: () {
                                  print("Share data");
                                },
                                icon: Icon(Icons.share, color: Colors.white),
                                label: Text("Share",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ));
      }),
    );
  }
}

class Scanner extends StatelessWidget {
  const Scanner({
    super.key,
    required this.viewModel,
  });

  final ScannerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  onTap: () {
                    viewModel.toggleScannerVisibility();
                  },
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
                        child: viewModel.isScannerVisible
                            ? SizedBox(
                                width: 175,
                                height: 175,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: MobileScanner(
                                    onDetect: (capture) {},
                                  ),
                                ),
                              )
                            : Column(
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
                      ),
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
    );
  }
}

class Math {
  static double pi = 3.1415926535897932;
}
