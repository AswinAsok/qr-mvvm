import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneratorViewModel extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  String qrData = '';
  List<String> generatedQRCodes = [];

  void generateQRCode() {
    qrData = textController.text;
    if (qrData.isNotEmpty) {
      generatedQRCodes.add(qrData);
      textController.clear(); // Clear the input field
      notifyListeners();
    }
  }

  Future<void> copyToClipboard() async {
    if (qrData.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: qrData));
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
