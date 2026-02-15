import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';

/// Service to check internet connectivity.
/// Uses multiple endpoints to ensure actual internet access,
/// works globally including regions where Google is blocked.
class ConnectivityService {
  
  // Multiple endpoints for global availability
  static const List<String> _endpoints = [
    'google.com',      // Primary - works in most regions
    'cloudflare.com',  // Fallback - works in China and blocked regions
    '1.1.1.1',         // Cloudflare DNS IP - direct IP fallback
  ];
  
  /// Checks if the device has internet access.
  /// Tries multiple endpoints for global compatibility.
  /// Returns `true` if connected, `false` otherwise.
  static Future<bool> get isConnected async {
    try {
      final result = await Future.any(
        _endpoints.map((endpoint) =>
          InternetAddress.lookup(endpoint).timeout(const Duration(seconds: 3))
        ),
      );
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('ConnectivityService: Connected');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('ConnectivityService: All endpoints failed - no internet');
      return false;
    }
  }
}
