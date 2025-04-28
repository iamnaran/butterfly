part of 'mqtt_bloc.dart';

abstract class MqttState {
  final MqttConnectionState? connectionState;
  const MqttState({this.connectionState});
}

class MqttInitial extends MqttState {
  const MqttInitial() : super(connectionState: MqttConnectionState.disconnected);
}

class MqttConnecting extends MqttState {
  const MqttConnecting() : super(connectionState: MqttConnectionState.connecting);
}

class MqttConnected extends MqttState {
  const MqttConnected() : super(connectionState: MqttConnectionState.connected);
}

class MqttDisconnected extends MqttState {
  const MqttDisconnected() : super(connectionState: MqttConnectionState.disconnected);
}

class MqttConnectionFailed extends MqttState {
  final String? error;
  const MqttConnectionFailed({this.error}) : super(connectionState: MqttConnectionState.faulted);
}

class MqttMessageReceived extends MqttState {
  final String topic;
  final String message;
  const MqttMessageReceived({required this.topic, required this.message});
}