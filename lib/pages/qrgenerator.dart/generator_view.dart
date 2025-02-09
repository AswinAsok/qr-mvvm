import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'generator_view_model.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class GeneratorView extends StatefulWidget {
  const GeneratorView({super.key});

  @override
  _GeneratorViewState createState() => _GeneratorViewState();
}

class _GeneratorViewState extends State<GeneratorView> {
  bool _showLottie = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _showLottie = !_showLottie;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<int> _fetchGitHubStars() async {
    final response = await http
        .get(Uri.parse('https://api.github.com/repos/AswinAsok/qr-mvvm'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Stars: ${data['stargazers_count']}");
      return data['stargazers_count'];
    } else {
      print("Failed to load stars: ${response.statusCode}");
      throw Exception('Failed to load stars');
    }
  }

  void _showConfirmationModal(
      BuildContext context, String action, VoidCallback onConfirm) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Confirm Deletion?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('Are you sure you want to $action?'),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(186, 33, 32, 35),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onConfirm();
                        Navigator.of(context).pop();
                        FocusScope.of(context).unfocus(); // Remove focus
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

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey globalKey = GlobalKey();
    return ChangeNotifierProvider(
      create: (_) => GeneratorViewModel(),
      child: Consumer<GeneratorViewModel>(builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            title: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  'QR Generator',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            backgroundColor: Color(0xFF212023),
            actions: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder<int>(
                  future: _fetchGitHubStars(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return GestureDetector(
                        onTap: () async {
                          const url = 'https://github.com/AswinAsok/qr-mvvm';
                          final Uri uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              _showLottie
                                  ? Lottie.asset('assets/wink.json', width: 24)
                                  : Icon(Icons.star_half_outlined,
                                      color: Color.fromARGB(255, 235, 255, 87)),
                              SizedBox(width: 2),
                              Text(
                                '${snapshot.data} stars',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(
                        top: 0, bottom: 10, left: 20, right: 20),
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
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize
                          .min, // Important: constrains Column's size
                      children: [
                        if (viewModel.qrData.isNotEmpty) ...[
                          Center(
                            child: Column(
                              mainAxisSize:
                                  MainAxisSize.min, // Constrains inner Column
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: RepaintBoundary(
                                    key: globalKey,
                                    child: QrImageView(
                                      data: viewModel.qrData,
                                      version: QrVersions.auto,
                                      size: 160.0,
                                      backgroundColor: Colors.white,
                                      errorStateBuilder: (context, error) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          _showErrorDialog(context,
                                              'Failed to generate QR code.');
                                        });
                                        return Center(
                                          child: Text(
                                            'Error',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
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
                              Icons.qr_code_scanner_rounded,
                              color: Color(0xFF212023),
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Scan QR",
                              style: TextStyle(
                                fontSize: 18,
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
                            context.go('/');
                          },
                          label: Text(
                            "Scan Now",
                            style: TextStyle(
                              color: Color(0xFF212023),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(15),
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
                                viewModel.generatedQRCodes.isNotEmpty
                                    ? "Generated QRs (${viewModel.generatedQRCodes.length})"
                                    : "Generated QRs",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (viewModel.generatedQRCodes.isNotEmpty)
                                ElevatedButton(
                                  onPressed: () {
                                    _showConfirmationModal(context, 'clear all',
                                        () {
                                      viewModel.clearQRCodes();
                                      Fluttertoast.showToast(
                                          msg: "All QR Codes cleared!");
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(186, 33, 32, 35),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    "Clear All",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Expanded(
                            child: viewModel.generatedQRCodes.isNotEmpty
                                ? ListView.builder(
                                    itemCount:
                                        viewModel.generatedQRCodes.length,
                                    padding: EdgeInsets.only(
                                        bottom:
                                            80), // Add padding for the overlay
                                    itemBuilder: (context, index) {
                                      final qrCode =
                                          viewModel.generatedQRCodes[index];
                                      return GestureDetector(
                                        onTap: () {
                                          if (viewModel.qrData == qrCode.data) {
                                            viewModel.qrData = '';
                                          } else {
                                            viewModel.setQRData(index);
                                          }
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 0),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 15),
                                                      decoration: BoxDecoration(
                                                        color: viewModel
                                                                    .qrData ==
                                                                qrCode.data
                                                            ? Color.fromARGB(
                                                                144,
                                                                235,
                                                                255,
                                                                87)
                                                            : Colors.grey[100],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                          qrCode.data,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors
                                                                  .black45),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    child: IconButton(
                                                      icon: Icon(
                                                          viewModel.qrData ==
                                                                  qrCode.data
                                                              ? Icons.visibility
                                                              : Icons.qr_code),
                                                      onPressed: () {
                                                        if (viewModel.qrData ==
                                                            qrCode.data) {
                                                          viewModel.qrData = '';
                                                        } else {
                                                          viewModel
                                                              .setQRData(index);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    child: IconButton(
                                                      icon: Icon(Icons.delete),
                                                      onPressed: () {
                                                        _showConfirmationModal(
                                                            context, 'delete',
                                                            () {
                                                          viewModel
                                                              .removeQRCode(
                                                                  index);
                                                          if (viewModel
                                                                  .qrData ==
                                                              qrCode.data) {
                                                            viewModel.qrData =
                                                                '';
                                                          }
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "QR Code deleted!");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Text(
                                                DateFormat(
                                                        'd MMM, yyyy - hh:mm a')
                                                    .format(qrCode.date),
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      "No QR codes generated yet.\nTry generating one below!",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF212023),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      10,
                      9,
                      10,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF212023),
                      borderRadius: BorderRadius.circular(
                        50,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 100,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: viewModel.textController,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            cursorColor: Colors.white54,
                            decoration: InputDecoration(
                              hintText: 'Enter data to generate',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEBFF57),
                            foregroundColor: Color(0xFF212023),
                          ),
                          onPressed: () {
                            viewModel.generateQRCode();
                            FocusScope.of(context)
                                .unfocus(); // automatically hide keyboard
                          },
                          icon: Icon(Icons.qr_code,
                              color: Colors.black, size: 20),
                          label: Text(
                            'Generate',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
