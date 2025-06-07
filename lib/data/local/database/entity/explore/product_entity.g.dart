// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductEntityAdapter extends TypeAdapter<ProductEntity> {
  @override
  final int typeId = 2;

  @override
  ProductEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductEntity(
      id: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      price: fields[4] as double,
      discountPercentage: fields[5] as double,
      rating: fields[6] as double,
      stock: fields[7] as int,
      images: (fields[8] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.discountPercentage)
      ..writeByte(6)
      ..write(obj.rating)
      ..writeByte(7)
      ..write(obj.stock)
      ..writeByte(8)
      ..write(obj.images);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
