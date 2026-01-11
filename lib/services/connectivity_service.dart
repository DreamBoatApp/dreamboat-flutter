import 'dart:io';

/// Service to check internet connectivity.
/// Uses a real lookup to google.com to ensure actual internet access,
/// not just a network interface connection.
class ConnectivityService {
  
  /// Checks if the device has internet access.
  /// Returns `true` if connected, `false` otherwise.
  static Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
