import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Network service providing custom HTTP clients with configurable SSL bypass
/// for connecting to Odoo servers with self-signed certificates
class NetworkService {
  /// Get a custom HTTP client with optional SSL certificate bypass
  /// 
  /// This is useful for connecting to Odoo servers with self-signed certificates
  /// or internal environments where certificate validation may fail.
  /// 
  /// The SSL bypass can be enabled/disabled via app settings for production safety.
  /// 
  /// WARNING: SSL bypass reduces security by accepting all certificates.
  /// Use with caution and only enable when necessary.
  static Future<http.BaseClient> getClient() async {
    final prefs = await SharedPreferences.getInstance();
    final sslBypassEnabled = prefs.getBool('ssl_bypass_enabled') ?? false;

    if (sslBypassEnabled) {
      final httpClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      return IOClient(httpClient);
    } else {
      // Use default HTTP client but ensure it's a BaseClient
      return IOClient(HttpClient());
    }
  }

  /// Enable or disable SSL bypass
  static Future<void> setSslBypassEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ssl_bypass_enabled', enabled);
  }

  /// Check if SSL bypass is currently enabled
  static Future<bool> isSslBypassEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('ssl_bypass_enabled') ?? false;
  }
}
