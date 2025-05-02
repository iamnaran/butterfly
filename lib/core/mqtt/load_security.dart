import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

Future<SecurityContext> createSecurityContext() async {
  final context = SecurityContext();

  // Load PEM contents from assets
  final caCert = await rootBundle.loadString('assets/cert/ca_cert.pem');
  final clientCert = await rootBundle.loadString('assets/cert/client_cert.pem');
  final clientKey = await rootBundle.loadString('assets/cert/client_key.pem');

  // Create temporary files
  final tempDir = Directory.systemTemp;
  final caFile = File('${tempDir.path}/ca.pem')..writeAsStringSync(caCert);
  final certFile = File('${tempDir.path}/client_cert.pem')..writeAsStringSync(clientCert);
  final keyFile = File('${tempDir.path}/client_key.pem')..writeAsStringSync(clientKey);

  // print what strings are being written to the files
  print('Loading only Private Keys File Certificate: $caCert');

  // Configure SecurityContext

  context.setTrustedCertificates(caFile.path);
  context.useCertificateChain(certFile.path);
  context.usePrivateKey(keyFile.path);

  return context;
}