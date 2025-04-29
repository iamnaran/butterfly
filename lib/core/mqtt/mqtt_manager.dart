// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
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

  String? caCertPath;
  String? clientCertPath;
  String? clientKeyPath;

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
    required String token,
    required String sessionId,
  }) {
    this.broker = broker;
    this.username = username;
    this.password = password;
    this.token = token;
    this.sessionId = sessionId;
  }

  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;
  final Duration _reconnectDelay = const Duration(seconds: 5);

  Future<void> connect() async {
    _connectionStatusController.add(MqttConnectionState.connecting);

    _client = MqttServerClient.withPort(broker!, clientId!, 1883);

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientId!)
        .withWillQos(MqttQos.atLeastOnce)
        .startClean();

    // ack msg

    if (username != null && password != null) {
      connMess.authenticateAs(username!, password!);
    }

    if (caCertPath != null && clientCertPath != null && clientKeyPath != null) {
      try {
        final caCert = await getHardcodedCaCert();
        final clientCert = await getHardcodedClientCert();
        final clientKey = await getHardcodedClientKey();

        if (caCert == null || clientCert == null || clientKey == null) {
          throw Exception('Certificate or key is missing.');
        }

        final securityContext = SecurityContext(withTrustedRoots: true)
          ..setClientAuthoritiesBytes(caCert.codeUnits)
          ..useCertificateChainBytes(clientCert.codeUnits)
          ..usePrivateKeyBytes(clientKey.codeUnits)
          ..setTrustedCertificatesBytes(caCert.codeUnits)
          ..minimumTlsProtocolVersion = TlsProtocolVersion.tls1_2;

        _client!.securityContext = securityContext;
      } catch (e) {
        debugPrint('Error loading certificates: $e');
        _connectionStatusController.add(MqttConnectionState.faulted);
        return;
      }
    }

    _client!.logging(on: true);
    _client!.setProtocolV311();

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

    _client!.connectionMessage = connMess; // Assign the connect message

    try {
      await _client!.connect();
    } on NoConnectionException catch (e) {
      if (!_connectionStatusController.isClosed) {
        _connectionStatusController.add(MqttConnectionState.faulted);
      }
      _connectionCompleter.isCompleted
          ? null
          : _connectionCompleter.completeError(e);
      debugPrint('MQTT client exception - No connection: $e');
      _disconnect();
    } on SocketException catch (e) {
      if (!_connectionStatusController.isClosed) {
        _connectionStatusController.add(MqttConnectionState.faulted);
      }
      _connectionStatusController.add(MqttConnectionState.faulted);
      debugPrint('MQTT client exception - Socket exception: $e');
      if (!_connectionCompleter.isCompleted) {
        _connectionCompleter.completeError('Max reconnection attempts failed');
      }
      _reconnect();
    }
  }

  Future<void> _reconnect() async {
    if (_reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      debugPrint(
          'Attempting to reconnect in ${_reconnectDelay.inSeconds} seconds (Attempt $_reconnectAttempts of $_maxReconnectAttempts)');
      await Future.delayed(_reconnectDelay);
      connect(); // Call connect again
    } else {
      debugPrint(
          'Max reconnection attempts reached. Connection failed permanently.');
      _disconnect(); // Ensure resources are cleaned up
    }
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

  static Future<String?> getHardcodedCaCert() async {
    return """
  -----BEGIN CERTIFICATE-----
  ...YOUR CERT...
  -----END CERTIFICATE-----
  """;
  }

  static Future<String?> getHardcodedClientCert() async {
    return """
  -----BEGIN CERTIFICATE-----
  ...YOUR CLIENT CERT...
  -----END CERTIFICATE-----
  """;
  }

  static Future<String?> getHardcodedClientKey() async {
    return """
  -----BEGIN PRIVATE KEY-----
  ...YOUR PRIVATE KEY...
  -----END PRIVATE KEY-----
  """;
  }

  void dispose() {
    _disconnect();
    _connectionStatusController.close();
  }

  String generateUUIDString() {
    const uuid = Uuid();
    return uuid.v4();
  }
}
