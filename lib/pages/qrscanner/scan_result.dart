import 'package:hive/hive.dart';

part 'scan_result.g.dart';

@HiveType(typeId: 0)
class ScanResult extends HiveObject {
  @HiveField(0)
  final String result;

  @HiveField(1)
  final DateTime createdAt;

  ScanResult({required this.result, required this.createdAt});
}
