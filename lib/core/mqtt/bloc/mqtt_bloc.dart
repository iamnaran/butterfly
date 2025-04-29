// ignore_for_file: invalid_use_of_visible_for_testing_member, avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:butterfly/core/mqtt/mqtt_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';

part 'mqtt_event.dart';
part 'mqtt_state.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  final MQTTConnection _mqttConnection;
  StreamSubscription<MqttConnectionState>? _connectionStatusSubscription;

  MqttBloc(this._mqttConnection) : super(MqttInitial()) {
    on<MqttConnectRequested>(_onMqttConnectRequested);
    on<MqttDisconnectRequested>(_onMqttDisconnectRequested);

    _connectionStatusSubscription =
        _mqttConnection.connectionStatusStream.listen((status) {
      debugPrint('MQTT Connection Status: $status');
      switch (status) {
        case MqttConnectionState.connecting:
          emit(MqttConnecting());
          break;
        case MqttConnectionState.connected:
          emit(MqttConnected());
          break;
        case MqttConnectionState.disconnected:
          emit(MqttDisconnected());
          break;
        case MqttConnectionState.faulted:
          emit(MqttConnectionFailed(error: _mqttConnection.client?.connectionStatus?.state.toString()));
          break;
        default:
          emit(MqttDisconnected());
      }
    });
  }

  Future<void> _onMqttConnectRequested(
    MqttConnectRequested event,
    Emitter<MqttState> emit,
  ) async {
    if (state is! MqttConnecting && state is! MqttConnected) {
      emit(MqttConnecting());
      await _mqttConnection.connect();
    }
  }

  Future<void> _onMqttDisconnectRequested(
    MqttDisconnectRequested event,
    Emitter<MqttState> emit,
  ) async {
    if (state is MqttConnected) {
      emit(MqttConnecting()); // Indicate disconnection in progress
      await _mqttConnection.disconnect();
      emit(MqttDisconnected());
    }
  }

  // Add methods here to handle subscribing, unsubscribing, publishing

  @override
  Future<void> close() {
    _connectionStatusSubscription?.cancel();
    _mqttConnection.dispose();
    return super.close();
  }
}
