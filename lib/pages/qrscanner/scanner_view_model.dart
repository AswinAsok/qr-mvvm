import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:makemyqr/pages/qrscanner/scan_result.dart';

class ScannerViewModel extends ChangeNotifier {
  bool _isScannerVisible = false;
  final List<ScanResult> _recentScans = [];
  List<ScanResult> _filteredScans = [];
  final Box<ScanResult> _scanBox = Hive.box<ScanResult>('scanResults');

  bool get isScannerVisible => _isScannerVisible;
  List<ScanResult> get recentScans {
    List<ScanResult> scans =
        _filteredScans.isEmpty ? _recentScans : _filteredScans;
    scans.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return scans;
  }

  ScannerViewModel() {
    _loadScans();
  }

  void _loadScans() {
    _recentScans.addAll(_scanBox.values);
    _filteredScans = _recentScans;
    notifyListeners();
  }

  void toggleScannerVisibility() {
    _isScannerVisible = !_isScannerVisible;
    notifyListeners();
  }

  void addScanResult(String result) {
    final scanResult = ScanResult(result: result, createdAt: DateTime.now());
    _recentScans.add(scanResult);
    _scanBox.add(scanResult);
    _isScannerVisible = false;
    notifyListeners();
  }

  void clearScans() {
    _recentScans.clear();
    _filteredScans.clear();
    _scanBox.clear();
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

  void removeScanResult(int index) {
    _scanBox.deleteAt(index);
    _recentScans.removeAt(index);
    notifyListeners();
  }
}
