import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'generator_view_model.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class GeneratorView extends StatelessWidget {
  const GeneratorView({super.key});

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

  @override
  Widget build(BuildContext context) {
    final GlobalKey globalKey = GlobalKey();
    return ChangeNotifierProvider(
      create: (_) => GeneratorViewModel(),
      child: Consumer<GeneratorViewModel>(builder: (context, viewModel, child) {
        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(
                        top: 60, bottom: 20, left: 20, right: 20),
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
                      children: [
                        Row(
                          children: [
                            Text(
                              'QR Generator',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(width: 40),
                          ],
                        ),
                        if (viewModel.qrData.isNotEmpty) ...[
                          SizedBox(height: 20),
                          Center(
                            child: Column(
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
                                      size: 150.0,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      padding:
                                          EdgeInsets.fromLTRB(20, 10, 10, 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            viewModel.qrData,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        ],
                                      )),
                                ),
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
                              size: 24,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Scan QR",
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
                            context.go('/');
                          },
                          label: Text("Scan Now",
                              style: TextStyle(
                                  color: Color(0xFF212023),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
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
                                viewModel.generatedQRCodes.isNotEmpty
                                    ? "Generated QRs (${viewModel.generatedQRCodes.length})"
                                    : "Generated QRs",
                                style: TextStyle(
                                  fontSize: 18,
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: viewModel.generatedQRCodes.isNotEmpty
                                ? ListView.builder(
                                    itemCount:
                                        viewModel.generatedQRCodes.length,
                                    padding: EdgeInsets.only(
                                        bottom:
                                            80), // Add padding for the overlay
                                    itemBuilder: (context, index) {
                                      final qrData =
                                          viewModel.generatedQRCodes[index];
                                      return ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 0,
                                        ),
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 15,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text(
                                                    qrData,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 30,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.qr_code,
                                                  color: Color(0xFF212023),
                                                ),
                                                onPressed: () {
                                                  viewModel.setQRData(index);
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              child: IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  _showConfirmationModal(
                                                      context, 'delete', () {
                                                    viewModel
                                                        .removeQRCode(index);
                                                    if (viewModel.qrData ==
                                                        qrData) {
                                                      viewModel.qrData = '';
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
                                          DateFormat('d MMM, yyyy - hh:mm a')
                                              .format(DateTime.now()),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
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
                          onPressed: () => viewModel.generateQRCode(),
                          icon: Icon(Icons.qr_code, color: Colors.black),
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
