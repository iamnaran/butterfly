// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dimension_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DimensionEntityAdapter extends TypeAdapter<DimensionEntity> {
  @override
  final int typeId = 3;

  @override
  DimensionEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DimensionEntity(
      width: fields[0] as double,
      height: fields[1] as double,
      depth: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DimensionEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.width)
      ..writeByte(1)
      ..write(obj.height)
      ..writeByte(2)
      ..write(obj.depth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DimensionEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
