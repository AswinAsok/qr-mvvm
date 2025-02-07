import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class QRCode {
  final String data;
  final DateTime date;

  QRCode(this.data, this.date);

  Map<String, dynamic> toJson() => {
        'data': data,
        'date': date.toIso8601String(),
      };

  factory QRCode.fromJson(Map<String, dynamic> json) => QRCode(
        json['data'],
        DateTime.parse(json['date']),
      );
}

class GeneratorViewModel extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  String qrData = '';
  List<QRCode> generatedQRCodes = [];
  final Box<String> _qrBox = Hive.box<String>('generatedQRCodes');

  GeneratorViewModel() {
    _loadQRCodes();
  }

  void generateQRCode() {
    final data = textController.text.trim();
    if (data.isNotEmpty) {
      // Check for duplicates
      if (!generatedQRCodes.any((qrCode) => qrCode.data == data)) {
        final newQRCode = QRCode(data, DateTime.now());
        generatedQRCodes.insert(0, newQRCode); // Insert new QR code at the top
        qrData = data;
        textController.clear();
        saveQRCode(newQRCode);
        notifyListeners();
      }
    }
  }

  Future<void> copyToClipboard() async {
    if (qrData.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: qrData));
    }
  }

  void removeQRCode(int index) {
    if (qrData == generatedQRCodes[index].data) {
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
    final qrCodeStrings = _qrBox.values.toList();
    generatedQRCodes = qrCodeStrings
        .map((e) {
          try {
            return QRCode.fromJson(Map<String, dynamic>.from(jsonDecode(e)));
          } catch (error) {
            print('Error decoding QR code: $error');
            return null;
          }
        })
        .where((qrCode) => qrCode != null)
        .toList()
        .cast<QRCode>();
    generatedQRCodes.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  void setQRData(int index) {
    qrData = generatedQRCodes[index].data;
    notifyListeners();
  }

  Future<void> saveQRCode(QRCode qrCode) async {
    await _qrBox.add(jsonEncode(qrCode.toJson()));
    notifyListeners();
  }
}
