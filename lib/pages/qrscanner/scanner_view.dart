import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qrmvvm/pages/qrscanner/scanner_view_model.dart';
import 'package:qrmvvm/pages/qrscanner/qr_scanner_corner.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScannerViewModel(),
      child: Consumer<ScannerViewModel>(builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            title: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'QR Scanner',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            backgroundColor: Color(0xFF212023),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: Icon(Icons.star_outline_rounded),
                  color: Colors.white,
                  hoverColor: Color(0xFFEBFF57),
                  onPressed: () {
                    // Handle about icon press
                  },
                ),
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Scanner(viewModel: viewModel),
                    SizedBox(height: 20),
                    GenerateButton(),
                    SizedBox(height: 20),
                    RecentScans(viewModel: viewModel),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class GenerateButton extends StatelessWidget {
  const GenerateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Color(0xfffdfdfd),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              spreadRadius: 10,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.qr_code,
                color: Color(0xFF212023),
                size: 24,
              ),
              SizedBox(width: 10),
              Text(
                "Generate QR",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: Color(0xFF212023),
              backgroundColor: Color(0xFFEBFF57),
            ),
            onPressed: () {
              context.go('/generator');
            },
            label: Text("Generate",
                style: TextStyle(
                    color: Color(0xFF212023),
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class ScanInfo extends StatelessWidget {
  const ScanInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color: Color(0xFF212023),
                  size: 24,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                    backgroundColor: Color(0xFF212023),
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.copy, color: Colors.white),
                  label: Text("Copy", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF212023),
                  ),
                  onPressed: () async {},
                  icon: Icon(Icons.open_in_browser, color: Colors.white),
                  label: Text("Open in Browser",
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF212023),
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.share, color: Colors.white),
                  label: Text("Share", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Scanner extends StatefulWidget {
  const Scanner({super.key, required this.viewModel});

  final ScannerViewModel viewModel;

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 310,
      padding: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Color(0xFF212023),
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(25),
            bottomEnd: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              spreadRadius: 10,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Stack(
                children: [
                  Container(
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
                        widget.viewModel.toggleScannerVisibility();
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
                            child: widget.viewModel.isScannerVisible
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 175,
                                        height: 175,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: MobileScanner(
                                            onDetect: (capture) {
                                              final String result = capture
                                                      .barcodes
                                                      .first
                                                      .rawValue ??
                                                  '';
                                              widget.viewModel
                                                  .addScanResult(result);
                                            },
                                          ),
                                        ),
                                      ),
                                      Lottie.asset(
                                        'assets/sparkles.json',
                                        width: 200,
                                        height: 200,
                                      ),
                                    ],
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Lottie.asset(
                                        'assets/sparkles.json',
                                        width: 200,
                                        height: 200,
                                      ),
                                      Positioned(
                                        bottom: 40,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.qr_code_scanner,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                            SizedBox(height: 15),
                                            Text(
                                              "Tap to Scan",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Just place a QR code inside the frame and press above. It's not that hard :)",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showConfirmationDialog(
    BuildContext context, String message, VoidCallback onConfirm) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Confirm Deletion?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              message,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(186, 33, 32, 35),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFF212023),
                      backgroundColor: Color(0xFFEBFF57),
                    ),
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        color: Color(0xFF212023),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

class RecentScans extends StatelessWidget {
  const RecentScans({super.key, required this.viewModel});

  final ScannerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              spreadRadius: 10,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  viewModel.recentScans.isNotEmpty
                      ? "Recent Scans (${viewModel.recentScans.length})"
                      : "Recent Scans",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (viewModel.recentScans.isNotEmpty) ...[
                  ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog(
                        context,
                        "Are you sure you want to clear all scans?",
                        () {
                          viewModel.clearScans();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(186, 33, 32, 35),
                        foregroundColor: Colors.white),
                    child: Text(
                      "Clear All",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: viewModel.recentScans.isNotEmpty
                  ? ListView.builder(
                      itemCount: viewModel.recentScans.length,
                      itemBuilder: (context, index) {
                        final scan = viewModel.recentScans[index];
                        return ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      scan.result,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black45),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 24,
                                child: IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: scan.result));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Copied to clipboard')),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 24,
                                child: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _showConfirmationDialog(
                                      context,
                                      "Are you sure you want to delete this scan?",
                                      () {
                                        viewModel.removeScanResult(index);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            DateFormat('d MMM, yyyy - hh:mm a')
                                .format(scan.createdAt),
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "Wow, such emptiness.\n Maybe try scanning a QR code?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF212023),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class Math {
  static double pi = 3.1415926535897932;
}
