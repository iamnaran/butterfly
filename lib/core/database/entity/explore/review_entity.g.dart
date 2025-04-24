// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReviewEntityAdapter extends TypeAdapter<ReviewEntity> {
  @override
  final int typeId = 5;

  @override
  ReviewEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewEntity(
      rating: fields[0] as double,
      comment: fields[1] as String,
      date: fields[2] as String,
      reviewerName: fields[3] as String,
      reviewerEmail: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.rating)
      ..writeByte(1)
      ..write(obj.comment)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.reviewerName)
      ..writeByte(4)
      ..write(obj.reviewerEmail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
