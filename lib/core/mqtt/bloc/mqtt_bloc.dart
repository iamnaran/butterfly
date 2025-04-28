// ignore_for_file: invalid_use_of_visible_for_testing_member, avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:butterfly/core/mqtt/mqtt_manager.dart';
import 'package:butterfly/core/mqtt/mqtt_service.dart';
import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_client.dart';

part 'mqtt_event.dart';
part 'mqtt_state.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {

  final MQTTConnection _connection;
  MqttService _mqttService;

  final Map<String, StreamSubscription<MqttReceivedMessage<MqttMessage>>> _topicSubscriptions = {};

  MqttBloc(this._mqttService)
      : _connection = MQTTConnection(
          broker: 'YOUR_MQTT_BROKER_ADDRESS',
          clientId: 'YOUR_CLIENT_ID',
          username: 'YOUR_USERNAME',
          password: 'YOUR_PASSWORD',
          caCertPath: '',
          clientCertPath: '',
          clientKeyPath: '',
        ),
        super(const MqttInitial()) {
    _mqttService = MqttService(_connection);

    _connection.connectionStatusStream.listen((state) {
      switch (state) {
        case MqttConnectionState.connecting:
          emit(const MqttConnecting());
          break;
        case MqttConnectionState.connected:
          emit(const MqttConnected());
          break;
        case MqttConnectionState.disconnected:
          emit(const MqttDisconnected());
          _unsubscribeAll();
          break;
        case MqttConnectionState.faulted:
          emit(MqttConnectionFailed());
          _unsubscribeAll();
          break;
        default:
          break;
      }
    });

    on<MqttConnectRequested>((event, emit) async {
      emit(const MqttConnecting());
      try {
        await _mqttService.connect();
      } catch (e) {
        emit(MqttConnectionFailed(error: e.toString()));
      }
    });

    on<MqttDisconnectRequested>((event, emit) async {
      await _mqttService.disconnect();
      emit(const MqttDisconnected());
    });

  on<MqttSubscribeRequested>((event, emit) async {
      if (!_topicSubscriptions.containsKey(event.topic)) {
        await _mqttService.subscribe(event.topic);
        final messageStreamSubscription = _mqttService.messageStream.listen((receivedMessage) { // Renamed 'message' to 'receivedMessage' for clarity
          if (receivedMessage.topic == event.topic) {
            final MqttPublishPayload? payload = receivedMessage.payload as MqttPublishPayload?;
            if (payload != null) {
              final String payloadString =
                  MqttPublishPayload.bytesToStringAsString(payload.message);
              add(_MqttInternalMessageReceived(topic: event.topic, message: payloadString));
            } else {
              // Handle the case where the payload is null or not of the expected type
              print('Received message with null or unexpected payload on topic: ${receivedMessage.topic}');
            }
          }
        });
        _topicSubscriptions[event.topic] = messageStreamSubscription;
      }
    });

    on<MqttUnsubscribeRequested>((event, emit) async {
      if (_topicSubscriptions.containsKey(event.topicToRemove)) {
        await _topicSubscriptions[event.topicToRemove]!.cancel();
        _topicSubscriptions.remove(event.topicToRemove);
        await _mqttService.unsubscribe(event.topicToRemove);
      }
    });

    on<MqttPublishRequested>((event, emit) {
      _mqttService.publish(event.topic, event.message); // Pass optional qos
    });

    on<_MqttInternalMessageReceived>((event, emit) {
      emit(MqttMessageReceived(topic: event.topic, message: event.message));
    });
  }

 void _unsubscribeAll() {
    for (final subscription in _topicSubscriptions.values) {
      subscription.cancel();
    }
    _topicSubscriptions.clear();
  }

  @override
  Future<void> close() {
    _unsubscribeAll();
    _mqttService.dispose();
    _connection.dispose();
    return super.close();
  }
}

class _MqttInternalMessageReceived extends MqttEvent {
  final String topic;
  final String message;
  const _MqttInternalMessageReceived({required this.topic, required this.message});
}
