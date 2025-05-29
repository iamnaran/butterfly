import 'dart:io';
import 'package:flutter/services.dart';

class CertificateManager {
  static Future<SecurityContext> loadCertificates() async {
    final securityContext = SecurityContext(withTrustedRoots: true);
    try {
      // Load Client Certificate
      try {
        final clientCertData = await rootBundle.load('assets/cert/client.pem');
        securityContext.useCertificateChainBytes(clientCertData.buffer.asUint8List());
      } catch (e) {
        // Handle error appropriately, maybe throw or return a default context
      }

      // Load Private Key
      try {
        final privateKeyData = await rootBundle.load('assets/cert/client.key');
        securityContext.usePrivateKeyBytes(privateKeyData.buffer.asUint8List());
      } catch (e) {
        // Handle error appropriately
      }

      // Load Root CA Certificate (to trust the server)
      try {
        final rootCAData = await rootBundle.load('assets/cert/ca.cert');
        securityContext.setTrustedCertificatesBytes(rootCAData.buffer.asUint8List());
      } catch (e) {
        // Handle the error appropriately
      }

      return securityContext;
    } catch (e) {
      return SecurityContext(withTrustedRoots: true); // Or handle error as needed
    }
  }
}