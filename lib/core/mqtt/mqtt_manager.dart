// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTConnection {
  final String broker;
  final String clientId;
  final String? username;
  final String? password;

  final String? caCertPath;
  final String? clientCertPath;
  final String? clientKeyPath;

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
    required this.broker,
    required this.clientId,
    this.username,
    this.password,
    this.caCertPath,
    this.clientCertPath,
    this.clientKeyPath,
    this.defaultQos = MqttQos.atLeastOnce,
  });

  Future<void> connect() async {
    _connectionStatusController.add(MqttConnectionState.connecting);

    _client = MqttServerClient.withPort(broker, clientId, 8883);

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .withWillQos(MqttQos.atLeastOnce);

    
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

    _client!.onConnected = () {
      _connectionStatusController.add(MqttConnectionState.connected);
      _connectionCompleter.complete();
      debugPrint('MQTT client connected');
    };

    _client!.onDisconnected = () {
      if (_client!.connectionStatus?.disconnectionOrigin ==
          MqttDisconnectionOrigin.solicited) {
        _connectionStatusController.add(MqttConnectionState.disconnected);
        debugPrint('MQTT client disconnected');
      } else {
        _connectionStatusController.add(MqttConnectionState.faulted);
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
      _connectionStatusController.add(MqttConnectionState.faulted);
      _connectionCompleter.isCompleted
          ? null
          : _connectionCompleter.completeError(e);
      debugPrint('MQTT client exception - No connection: $e');
      _disconnect();
    } on SocketException catch (e) {
      _connectionStatusController.add(MqttConnectionState.faulted);
      _connectionCompleter.isCompleted
          ? null
          : _connectionCompleter.completeError(e);
      debugPrint('MQTT client exception - Socket exception: $e');
      _disconnect();
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
}
