import 'package:flutter/material.dart';
import 'package:qrmvvm/pages/qrscanner/models/scan_result.dart';

class ScannerViewModel extends ChangeNotifier {
  bool _isScannerVisible = false;
  final List<ScanResult> _recentScans = [];
  List<ScanResult> _filteredScans = [];

  bool get isScannerVisible => _isScannerVisible;
  List<ScanResult> get recentScans =>
      _filteredScans.isEmpty ? _recentScans : _filteredScans;

  ScannerViewModel() {
    _filteredScans = _recentScans;
  }

  void toggleScannerVisibility() {
    _isScannerVisible = !_isScannerVisible;
    notifyListeners();
  }

  void addScanResult(String result) {
    _recentScans.add(ScanResult(result: result, createdAt: DateTime.now()));
    _isScannerVisible = false;
    notifyListeners();
  }

  void searchScans(String query) {
    if (query.isEmpty) {
      _filteredScans = _recentScans;
    } else {
      _filteredScans = _recentScans
          .where(
              (scan) => scan.result.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
