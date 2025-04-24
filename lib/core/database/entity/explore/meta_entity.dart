
import 'package:hive/hive.dart';

part 'meta_entity.g.dart';

@HiveType(typeId: 4)
class MetaEntity {
  @HiveField(0)
  final String createdAt;

  @HiveField(1)
  final String updatedAt;

  @HiveField(2)
  final String barcode;

  @HiveField(3)
  final String qrCode;

  MetaEntity({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });
}