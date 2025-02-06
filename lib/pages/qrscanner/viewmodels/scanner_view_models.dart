import 'package:flutter/material.dart';

class ScannerViewModel extends ChangeNotifier {
  bool _isScannerVisible = false;

  bool get isScannerVisible => _isScannerVisible;

  void toggleScannerVisibility() {
    _isScannerVisible = !_isScannerVisible;
    notifyListeners();
  }
}
