import 'package:flutter/material.dart';

class GeneratorViewModel extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  String qrData = '';
  List<String> generatedQRCodes = [];

  void generateQRCode() {
    qrData = textController.text;
    if (qrData.isNotEmpty) {
      generatedQRCodes.add(qrData);
      notifyListeners();
    }
  }

  void removeQRCode(int index) {
    generatedQRCodes.removeAt(index);
    notifyListeners();
  }

  void clearQRCodes() {
    generatedQRCodes.clear();
    notifyListeners();
  }
}
