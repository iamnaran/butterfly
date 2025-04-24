
import 'package:hive/hive.dart';

part 'review_entity.g.dart';

@HiveType(typeId: 5)
class ReviewEntity {
  @HiveField(0)
  final double rating;

  @HiveField(1)
  final String comment;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String reviewerName;

  @HiveField(4)
  final String reviewerEmail;

  ReviewEntity({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });
}