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
      tags: (fields[8] as List).cast<String>(),
      brand: fields[9] as String,
      sku: fields[10] as String,
      weight: fields[11] as double,
      dimensions: fields[12] as DimensionEntity,
      warrantyInformation: fields[13] as String,
      shippingInformation: fields[14] as String,
      availabilityStatus: fields[15] as String,
      reviews: (fields[16] as List).cast<ReviewEntity>(),
      returnPolicy: fields[17] as String,
      minimumOrderQuantity: fields[18] as int,
      meta: fields[19] as MetaEntity,
      thumbnail: fields[20] as String,
      images: (fields[21] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductEntity obj) {
    writer
      ..writeByte(22)
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
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.brand)
      ..writeByte(10)
      ..write(obj.sku)
      ..writeByte(11)
      ..write(obj.weight)
      ..writeByte(12)
      ..write(obj.dimensions)
      ..writeByte(13)
      ..write(obj.warrantyInformation)
      ..writeByte(14)
      ..write(obj.shippingInformation)
      ..writeByte(15)
      ..write(obj.availabilityStatus)
      ..writeByte(16)
      ..write(obj.reviews)
      ..writeByte(17)
      ..write(obj.returnPolicy)
      ..writeByte(18)
      ..write(obj.minimumOrderQuantity)
      ..writeByte(19)
      ..write(obj.meta)
      ..writeByte(20)
      ..write(obj.thumbnail)
      ..writeByte(21)
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
