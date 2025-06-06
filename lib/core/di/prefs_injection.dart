import 'package:butterfly/core/preference/pref_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> registerPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerLazySingleton<PreferenceManager>(
    () => PreferenceManager(getIt<SharedPreferences>()),
  );
}