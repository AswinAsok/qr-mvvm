import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class GeneratorViewModel extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  String qrData = '';
  List<String> generatedQRCodes = [];
  final Box<String> _qrBox = Hive.box<String>('generatedQRCodes');

  GeneratorViewModel() {
    _loadQRCodes();
  }

  void generateQRCode() {
    qrData = textController.text;
    if (qrData.isNotEmpty) {
      saveQRCode(qrData);
      textController.clear(); // Clear the input field
      SystemChannels.textInput
          .invokeMethod('TextInput.hide'); // Close the keyboard
    }
  }

  Future<void> copyToClipboard() async {
    if (qrData.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: qrData));
    }
  }

  void removeQRCode(int index) {
    if (qrData == generatedQRCodes[index]) {
      qrData = '';
    }

    _qrBox.deleteAt(index);
    generatedQRCodes.removeAt(index);
    notifyListeners();
  }

  void clearQRCodes() {
    _qrBox.clear();
    qrData = '';
    generatedQRCodes.clear();
    notifyListeners();
  }

  void _loadQRCodes() {
    generatedQRCodes.addAll(_qrBox.values);
    notifyListeners();
  }

  void setQRData(int index) {
    qrData = generatedQRCodes[index];
    notifyListeners();
  }

  Future<void> saveQRCode(String qrData) async {
    await _qrBox.add(qrData);
    generatedQRCodes.add(qrData);
    notifyListeners();
  }
}
