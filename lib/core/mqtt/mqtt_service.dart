import 'dart:async';
import 'package:butterfly/core/mqtt/mqtt_manager.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MqttService {
  final MQTTConnection _connection;
  final StreamController<MqttReceivedMessage<MqttMessage>> _messageStreamController =
      StreamController<MqttReceivedMessage<MqttMessage>>.broadcast();
  Stream<MqttReceivedMessage<MqttMessage>> get messageStream =>
      _messageStreamController.stream;

 MqttService(this._connection) {
    _connection.client?.updates?.listen(_onMessageReceived);
  }

  Future<void> connect() async {
    await _connection.connect();
  }

  Future<void> disconnect() async {
    await _connection.disconnect();
  }

  Future<void> subscribe(String topic) async {
    await _connection.subscribe(topic);
  }

  Future<void> unsubscribe(String topic) async {
    await _connection.unsubscribe(topic);
  }

  void publish(String topic, String message) {
    _connection.publish(topic, message);
  }

  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (final MqttReceivedMessage<MqttMessage> message in messages) {
      _messageStreamController.add(message);
    }
  }

  void dispose() {
    _messageStreamController.close();
  }
}