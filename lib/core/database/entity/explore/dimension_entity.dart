
import 'package:hive/hive.dart';

part 'dimension_entity.g.dart';

@HiveType(typeId: 3)
class DimensionEntity {
  @HiveField(0)
  final double width;

  @HiveField(1)
  final double height;

  @HiveField(2)
  final double depth;

  DimensionEntity({
    required this.width,
    required this.height,
    required this.depth,
  });
}