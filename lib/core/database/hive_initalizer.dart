
import 'package:butterfly/core/database/entity/user/user_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(UserEntityAdapter());

}