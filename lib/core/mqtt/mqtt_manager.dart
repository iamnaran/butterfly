// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:butterfly/core/mqtt/load_security.dart';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';

class MQTTConnection {
  
  String? broker;
  String? clientId;
  String? username;
  String? password;
  String? token;
  String? sessionId;

  final MqttQos defaultQos;

  MqttServerClient? _client;
  MqttServerClient? get client => _client;

  final StreamController<MqttConnectionState> _connectionStatusController =
      StreamController<MqttConnectionState>.broadcast();

  Stream<MqttConnectionState> get connectionStatusStream =>
      _connectionStatusController.stream;

  MqttConnectionState? get connectionState => _client?.connectionStatus?.state;

  final Completer<void> _connectionCompleter = Completer<void>();
  Future<void> get onConnected => _connectionCompleter.future;

  MQTTConnection({
    this.defaultQos = MqttQos.atLeastOnce,
  }) {
    clientId = generateUUIDString();
  }

  void configure({
    required String broker,
    required String username,
    required String password,
    required String sessionId,
  }) {
    this.broker = broker;
    this.username = username;
    this.password = password;
    this.sessionId = sessionId;
  }

  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;
  final Duration _reconnectDelay = const Duration(seconds: 5);

  Future<void> connect() async {
    debugPrint('MQTT client Connect Called');

    _connectionStatusController.add(MqttConnectionState.connecting);

    // _client = MqttServerClient.withPort(broker!, clientId!, 443);

    _client = MqttServerClient(broker!, clientId!);
    _client!.secure = true;
    _client!.port = 443;

    try {
      _client!.securityContext = await CertificateManager.loadCertificates();
    } catch (e) {
      debugPrint('Error loading certificates: $e');
      _connectionStatusController.add(MqttConnectionState.faulted);
      return;
    }
    // check if security context is loaded

    _client!.logging(on: true);
    _client!.keepAlivePeriod = 60;
    _client!.setProtocolV311();

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientId!)
        .withWillQos(MqttQos.atLeastOnce)
        .startClean();

    // print username   password
    debugPrint('MQTT client username: $username');
    debugPrint('MQTT client password: $password');

    if (username != null && password != null) {
      connMess.authenticateAs(username!, password!);
    }

    _client!.onConnected = () {
      _connectionStatusController.add(MqttConnectionState.connected);
      _connectionCompleter.complete();
      debugPrint('MQTT client connected');
    };

    _client!.onDisconnected = () {
      if (_client!.connectionStatus?.disconnectionOrigin ==
          MqttDisconnectionOrigin.solicited) {
        if (!_connectionStatusController.isClosed) {
          _connectionStatusController.add(MqttConnectionState.disconnected);
        }
        debugPrint('MQTT client disconnected');
      } else {
        if (!_connectionStatusController.isClosed) {
          _connectionStatusController.add(MqttConnectionState.faulted);
        }
        _connectionCompleter.isCompleted
            ? null
            : _connectionCompleter.completeError('Connection failed');
        debugPrint('MQTT client connection failed');
      }
    };

    _client!.connectionMessage = connMess;

    try {
    debugPrint('Connecting to broker : $broker, $clientId, $username, $password');
    await _client!.connect();
  } on NoConnectionException catch (e) {
    debugPrint('MQTT client exception - No connection: $e');
    _connectionStatusController.add(MqttConnectionState.faulted);
    _connectionCompleter.completeError('Max reconnection attempts failed');
    _disconnect();
  } on SocketException catch (e) {
    debugPrint('SocketException: $e');
    _connectionStatusController.add(MqttConnectionState.faulted);
    _reconnect();
  } catch (e) {
    debugPrint('Unexpected error: $e');
    _connectionStatusController.add(MqttConnectionState.faulted);
    _connectionCompleter.completeError('Unexpected error: $e');
    _disconnect();
  }


  }

  Future<void> _reconnect() async {
  while (_reconnectAttempts < _maxReconnectAttempts) {
    _reconnectAttempts++;
    debugPrint(
        'Attempting to reconnect in ${_reconnectDelay.inSeconds} seconds (Attempt $_reconnectAttempts of $_maxReconnectAttempts)');
    await Future.delayed(_reconnectDelay);

    try {
      await connect(); // Try connecting again
      return; // If connection succeeds, break out of the loop
    } catch (e) {
      debugPrint('Reconnect attempt $_reconnectAttempts failed: $e');
    }
  }

  debugPrint('Max reconnection attempts reached. Connection failed permanently.');
  _disconnect(); // Ensure resources are cleaned up
}

  Future<void> disconnect() async {
    _disconnect();
  }

  void _disconnect() {
    if (_client != null &&
        _client!.connectionStatus!.state == MqttConnectionState.connected) {
      _client!.disconnect();
    }
    _client = null;
    if (!_connectionCompleter.isCompleted) {
      _connectionCompleter.completeError('Disconnected');
    }
  }

  Future<void> subscribe(String topic, [MqttQos? qos]) async {
    final qosToUse = qos ?? defaultQos;
    if (_client != null &&
        _client!.connectionStatus!.state == MqttConnectionState.connected) {
      _client!.subscribe(topic, qosToUse);
    } else {
      debugPrint('Cannot subscribe. Client is not connected.');
    }
  }

  Future<void> unsubscribe(String topic) async {
    if (_client != null &&
        _client!.connectionStatus!.state == MqttConnectionState.connected) {
      _client!.unsubscribe(topic);
    } else {
      debugPrint('Cannot unsubscribe. Client is not connected.');
    }
  }

  void publish(String topic, String message, [MqttQos? qos]) {
    final qosToUse = qos ?? defaultQos;
    if (_client != null &&
        _client!.connectionStatus!.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      _client!.publishMessage(topic, qosToUse, builder.payload!);
    } else {
      debugPrint('Cannot publish. Client is not connected.');
    }
  }

// ca cert
  void dispose() {
    _disconnect();
    _connectionStatusController.close();
  }

  String generateUUIDString() {
    const uuid = Uuid();
    return uuid.v4();
  }
}
