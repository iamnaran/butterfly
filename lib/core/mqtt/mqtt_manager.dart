// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:butterfly/utils/app_logger.dart';
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
    debugPrint('MQTT client Connect Called');

    _connectionStatusController.add(MqttConnectionState.connecting);

    // _client = MqttServerClient.withPort(broker!, clientId!, 1883);

    _client = MqttServerClient('test.mosquitto.org', 'client-idflutter_client_xasasa');
    _client!.port = 1883;

    // final MqttConnectMessage connMess = MqttConnectMessage()
    //     .withClientIdentifier(clientId!)
    //     .withWillQos(MqttQos.atLeastOnce)
    //     .startClean();

    // ack msg

    // if (username != null && password != null) {
    //   connMess.authenticateAs(username!, password!);
    // }

    // try {
    //   final caCert = await getCaCert();
    //   final clientCert = await getClientCert();
    //   final clientKey = await getClientKey();

    //   if (caCert == null || clientCert == null || clientKey == null) {
    //     throw Exception('Certificate or key is missing.');
    //   }
    //   // print ca cert
    //   debugPrint('CA Cert: $caCert');
    //   debugPrint('Client Cert: $clientCert');
    //   debugPrint('Client Key: $clientKey');

      // final securityContext = SecurityContext(withTrustedRoots: true)
      //   ..setTrustedCertificates()
      //   ..setClientAuthorities(utf8.encode(caCert))
      //   ..useCertificateChain(utf8.encode(clientCert))
      //   ..usePrivateKey())
    
    //   _client!.securityContext = securityContext;
    // } catch (e) {
    //   debugPrint('Error loading certificates: $e');
    //   _connectionStatusController.add(MqttConnectionState.faulted);
    //   return;
    // }

    _client!.logging(on: true);
    _client!.secure = false;
    _client!.keepAlivePeriod = 60;
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

    // _client!.connectionMessage = connMess; // Assign the connect message

    try {

      // print broker url, port
      debugPrint('Connecting to broker NEW : $broker, port: 1883');
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

// ca cert

  static Future<String?> getCaCert() async {
    return """
-----BEGIN CERTIFICATE-----
MIIDEzCCAfugAwIBAgIBAjANBgkqhkiG9w0BAQsFADA/MQswCQYDVQQGEwJDTjER
MA8GA1UECAwIaGFuZ3pob3UxDDAKBgNVBAoMA0VNUTEPMA0GA1UEAwwGUm9vdENB
MB4XDTIwMDUwODA4MDcwNVoXDTMwMDUwNjA4MDcwNVowPzELMAkGA1UEBhMCQ04x
ETAPBgNVBAgMCGhhbmd6aG91MQwwCgYDVQQKDANFTVExDzANBgNVBAMMBlNlcnZl
cjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALNeWT3pE+QFfiRJzKmn
AMUrWo3K2j/Tm3+Xnl6WLz67/0rcYrJbbKvS3uyRP/stXyXEKw9CepyQ1ViBVFkW
Aoy8qQEOWFDsZc/5UzhXUnb6LXr3qTkFEjNmhj+7uzv/lbBxlUG1NlYzSeOB6/RT
8zH/lhOeKhLnWYPXdXKsa1FL6ij4X8DeDO1kY7fvAGmBn/THh1uTpDizM4YmeI+7
4dmayA5xXvARte5h4Vu5SIze7iC057N+vymToMk2Jgk+ZZFpyXrnq+yo6RaD3ANc
lrc4FbeUQZ5a5s5Sxgs9a0Y3WMG+7c5VnVXcbjBRz/aq2NtOnQQjikKKQA8GF080
BQkCAwEAAaMaMBgwCQYDVR0TBAIwADALBgNVHQ8EBAMCBeAwDQYJKoZIhvcNAQEL
BQADggEBAJefnMZpaRDHQSNUIEL3iwGXE9c6PmIsQVE2ustr+CakBp3TZ4l0enLt
iGMfEVFju69cO4oyokWv+hl5eCMkHBf14Kv51vj448jowYnF1zmzn7SEzm5Uzlsa
sqjtAprnLyof69WtLU1j5rYWBuFX86yOTwRAFNjm9fvhAcrEONBsQtqipBWkMROp
iUYMkRqbKcQMdwxov+lHBYKq9zbWRoqLROAn54SRqgQk6c15JdEfg
-----END CERTIFICATE-----
  """;
  }

// client key

  static Future<String?> getClientKey() async {
    return """
  -----BEGIN PRIVATE KEY-----
MIIEpAIBAAKCAQEA7yhhQzfgTYV79Y3FlhQ93lD5e9fh+6tQfXql5w2/5kdmVG/J
X2A2Ay7B/52EjPB7xWErv3lbksJ6ApIMffkaEXeO3U5cuHaQJkcnx1dYIifEKXsY
s82cLTFpz/Kq6sqjttSfu2w0gt2nxaNKjxUV+g==
-----END PRIVATE KEY-----
  """;
  }

// client cert
  static Future<String?> getClientCert() async {
    return """
-----BEGIN CERTIFICATE-----
MIIDEzCCAfugAwIBAgIBATANBgkqhkiG9w0BAQsFADA/MQswCQYDVQQGEwJDTjER
MA8GA1UECAwIaGFuZ3pob3UxDDAKBgNVBAoMA0VNUTEPMA0GA1UEAwwGUm9vdENB
MB4XDTIwMDUwODA4MDY1N1oXDTMwMDUwNjA4MDY1N1owPzELMAkGA1UEBhMCQ04x
ETAPBgNVBAgMCGhhbmd6aG91MQwwCgYDVQQKDANFTVExDzANBgNVBAMMBkNsaWVu
dDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMy4hoksKcZBDbY680u6
TS25U51nuB1FBcGMlF9B/t057wPOlxF/OcmbxY5MwepS41JDGPgulE1V7fpsXkiW
1LUimYV/tsqBfymIe0mlY7oORahKji7zKQ2UBIVFhdlvQxunlIDnw6F9popUgyHt
dMhtlgZK8oqRwHxO5dbfoukYd6J/r+etS5q26sgVkf3C6dt0Td7B25H9qW+f7oLV
-----END CERTIFICATE-----
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
