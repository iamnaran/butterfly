part of 'mqtt_bloc.dart';

sealed class MqttEvent extends Equatable {
  const MqttEvent();

  @override
  List<Object> get props => [];
}

class MqttConnectRequested extends MqttEvent {}
class MqttDisconnectRequested extends MqttEvent {}
class MqttSubscribeRequested extends MqttEvent {
  final String topic;
  final MqttQos? qos; // Make qos optional here
  const MqttSubscribeRequested({required this.topic, this.qos});
}
class MqttUnsubscribeRequested extends MqttEvent {
  final String topicToRemove;
  const MqttUnsubscribeRequested({required this.topicToRemove});
}
class MqttPublishRequested extends MqttEvent {
  final String topic;
  final String message;
  const MqttPublishRequested({required this.topic, required this.message});
}

