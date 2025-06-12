import 'package:butterfly/data/local/database/entity/explore/product_entity.dart';
import 'package:butterfly/data/local/database/entity/post/post_entity.dart';
import 'package:butterfly/data/local/database/entity/user/user_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  deleteHiveDisk();
  Hive.registerAdapter(UserEntityAdapter());
  Hive.registerAdapter(ProductEntityAdapter());
  Hive.registerAdapter(PostEntityAdapter());
}

// delete hive
Future<void> deleteHiveDisk() async {
  await Hive.deleteFromDisk();
  await Hive.close();
}
