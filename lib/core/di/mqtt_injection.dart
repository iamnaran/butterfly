import 'package:get_it/get_it.dart';
import 'package:butterfly/core/mqtt/bloc/mqtt_bloc.dart';
import 'package:butterfly/core/mqtt/mqtt_manager.dart';

final getIt = GetIt.instance;

void registerMqtt() {
  getIt.registerLazySingleton<MQTTConnection>(() => MQTTConnection());

  getIt.registerFactory<MqttBloc>(() => MqttBloc(getIt<MQTTConnection>()));
}
