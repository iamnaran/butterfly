import 'dart:io';
import 'package:flutter/services.dart';

class CertificateManager {
  static Future<SecurityContext> loadCertificates() async {
    try {
      final context = SecurityContext(withTrustedRoots: true);

      // Load CA
      final caBytes = await _loadPemBytes("assets/cert/ca_cert.pem");
      if (caBytes != null) {
        context.setTrustedCertificatesBytes(caBytes);
        print("✅ CA certificate loaded successfully.");

      }

      // Load client certificate and private key
      final certBytes = await _loadPemBytes("assets/cert/client_cert.pem");
      final keyBytes = await _loadPemBytes("assets/cert/client_key.pem");

      if (certBytes != null && keyBytes != null) {

        context.useCertificateChainBytes(certBytes);
        context.usePrivateKeyBytes(keyBytes);
        print("✅ Certificate and private key loaded successfully.");

      }

      // print loaded certificates
      print("✅ Loaded CA, client certificate, and private key successfully.");

      return context;
    } catch (e) {
      throw Exception('❌ Failed to load certificates: $e');
    }
  }

  static Future<Uint8List?> _loadPemBytes(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);
      return data.buffer.asUint8List();
    } catch (e) {
      print("⚠️ Failed to read $assetPath: $e");
      return null;
    }
  }
}
