// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MetaEntityAdapter extends TypeAdapter<MetaEntity> {
  @override
  final int typeId = 4;

  @override
  MetaEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MetaEntity(
      createdAt: fields[0] as String,
      updatedAt: fields[1] as String,
      barcode: fields[2] as String,
      qrCode: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MetaEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.createdAt)
      ..writeByte(1)
      ..write(obj.updatedAt)
      ..writeByte(2)
      ..write(obj.barcode)
      ..writeByte(3)
      ..write(obj.qrCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetaEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
