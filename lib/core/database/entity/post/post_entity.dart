import 'package:hive/hive.dart';

part 'post_entity.g.dart'; 

@HiveType(typeId: 5) 
class PostEntity extends HiveObject {
  
  @HiveField(0)
  final int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  List<String> tags;

  @HiveField(4)
  ReactionHiveModel reactions;

  @HiveField(5)
  int views;

  @HiveField(6)
  int userId;

  PostEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.reactions,
    required this.views,
    required this.userId,
  });
}

@HiveType(typeId: 6) 
class ReactionHiveModel extends HiveObject {
  @HiveField(0)
  int likes;

  @HiveField(1)
  int dislikes;

  ReactionHiveModel({
    required this.likes,
    required this.dislikes,
  });
}