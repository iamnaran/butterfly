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
          emit(MqttConnectionFailed(
              error:
                  _mqttConnection.client?.connectionStatus?.state.toString()));
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
      // setup mqtt connection parameters
      // _mqttConnection.configure(
      //   broker: 'rt-internal-edge-a.anydone.us',
      //   username: '1fad32b9df374291832e1b1ec420fac7',
      //   password:
      //       'MWZhZDMyYjlkZjM3NDI5MTgzMmUxYjFlYzQyMGZhYzcuYTkxNGFiZjk2OTU0NDNiZDg2OTlhMDBkNTFhODEyMzE=.d4c0968d1b154f4452895cb522876eb0943268a5562199d5d801ec326f57d3d9c0f4860b716339b1b1110ad0d3174ffc40eb09203f5aeb9cb8fe224d3dd7b82f',
      //   token:
      //       'MDU0YTNjOTU2NzVjNDA2NGFjYTQwODM4ZmQwYzgwN2EuZjYyN2JhOGNlNjg4NDU2NDlhZTk4N2ViYWQ3NjQyM2M=.8bbff5cf9e417fb418d91a64c4c36097596e39858587bd3cfe80ca2b6a4e4b97fd3b99fcd398a968e1a8dcd93dfe2c1f79a4d369f0b40cb341e7e314c92e285e',
      //   sessionId: 'f627ba8ce68845649ae987ebad76423c',
      // );

      _mqttConnection.configure(
        broker: 'broker.hivemq.com',
        username: '1fad32b9df374291832e1b1ec420fac7',
        password:
            'MWZhZDMyYjlkZjM3NDI5MTgzMmUxYjFlYzQyMGZhYzcuYTkxNGFiZjk2OTU0NDNiZDg2OTlhMDBkNTFhODEyMzE=.d4c0968d1b154f4452895cb522876eb0943268a5562199d5d801ec326f57d3d9c0f4860b716339b1b1110ad0d3174ffc40eb09203f5aeb9cb8fe224d3dd7b82f',
        token:
            'MDU0YTNjOTU2NzVjNDA2NGFjYTQwODM4ZmQwYzgwN2EuZjYyN2JhOGNlNjg4NDU2NDlhZTk4N2ViYWQ3NjQyM2M=.8bbff5cf9e417fb418d91a64c4c36097596e39858587bd3cfe80ca2b6a4e4b97fd3b99fcd398a968e1a8dcd93dfe2c1f79a4d369f0b40cb341e7e314c92e285e',
        sessionId: 'f627ba8ce68845649ae987ebad76423c',
      );
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
