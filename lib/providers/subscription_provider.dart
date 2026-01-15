import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionProvider extends ChangeNotifier {
  bool _isPro = false;
  bool _isLoading = true;
  bool _isRestoring = false;
  bool _isConfigured = false;  // Track if RevenueCat is configured
  CustomerInfo? _customerInfo;
  Offerings? _offerings;

  // RevenueCat API Key (Production - Play Store)
  static const String _revenueCatApiKey = 'goog_LBAhypBGyaAupCMVbaViawqANGq';
  
  // Entitlement identifier from RevenueCat dashboard
  static const String _proEntitlement = 'pro';

  bool get isPro => _isPro;
  bool get isLoading => _isLoading;
  bool get isRestoring => _isRestoring;
  Offerings? get offerings => _offerings;
  CustomerInfo? get customerInfo => _customerInfo;

  SubscriptionProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    debugPrint('=== SubscriptionProvider _initialize START ===');
    
    // 1. Load cached status for immediate UI (fail-open)
    try {
      final prefs = await SharedPreferences.getInstance();
      _isPro = prefs.getBool('is_pro_version') ?? false;
      debugPrint('Loaded cached isPro: $_isPro');
    } catch (e) {
      debugPrint('SharedPreferences error: $e');
    }
    
    _isLoading = false;
    notifyListeners();

    // 2. Configure RevenueCat in isolate/background after delay
    // Using compute or delayed initialization to avoid blocking
    Future.delayed(const Duration(seconds: 1), () {
      _configureRevenueCat();
    });
  }

  Future<void> _configureRevenueCat() async {
    try {
      debugPrint('=== Configuring RevenueCat (background) ===');
      
      // Configure with timeout to prevent hanging
      await Purchases.configure(PurchasesConfiguration(_revenueCatApiKey))
          .timeout(const Duration(seconds: 10), onTimeout: () {
        debugPrint('RevenueCat configure timed out');
        throw TimeoutException('RevenueCat configure timed out');
      });
      
      _isConfigured = true;
      debugPrint('RevenueCat configured successfully');
      
      // Get customer info with timeout
      try {
        _customerInfo = await Purchases.getCustomerInfo()
            .timeout(const Duration(seconds: 5));
        _updateProStatus(_customerInfo);
        debugPrint('Customer info retrieved');
      } catch (e) {
        debugPrint('Customer info error: $e');
      }
      
      // Load offerings with timeout
      try {
        _offerings = await Purchases.getOfferings()
            .timeout(const Duration(seconds: 5));
        debugPrint('Offerings loaded: ${_offerings?.current?.identifier ?? "none"}');
        notifyListeners();
      } catch (e) {
        debugPrint('Offerings error: $e');
      }
      
      // Listen for customer info updates
      Purchases.addCustomerInfoUpdateListener((customerInfo) {
        _customerInfo = customerInfo;
        _updateProStatus(customerInfo);
      });
      
      debugPrint('=== RevenueCat initialization COMPLETE. isPro: $_isPro ===');
    } catch (e, stackTrace) {
      debugPrint('RevenueCat initialization error: $e');
      debugPrint('Stack: $stackTrace');
      // Keep cached status on error (fail-open)
    }
  }

  void _updateProStatus(CustomerInfo? customerInfo) async {
    final hasPro = customerInfo?.entitlements.active.containsKey(_proEntitlement) ?? false;
    
    if (hasPro != _isPro) {
      _isPro = hasPro;
      
      // Cache the status
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_pro_version', _isPro);
      } catch (e) {
        debugPrint('Cache error: $e');
      }
      
      notifyListeners();
    }
  }

  /// User-triggered restore purchases functionality (required for App Store)
  /// Returns: 'success' if PRO was restored, 'not_found' if no purchases found, 'error' on failure
  Future<String> restorePurchases() async {
    if (!_isConfigured) {
      debugPrint('RevenueCat not configured, cannot restore');
      return 'error';
    }
    
    _isRestoring = true;
    notifyListeners();

    try {
      _customerInfo = await Purchases.restorePurchases();
      _updateProStatus(_customerInfo);
      
      _isRestoring = false;
      notifyListeners();
      
      return _isPro ? 'success' : 'not_found';
    } catch (e) {
      debugPrint('Restore purchases error: $e');
      _isRestoring = false;
      notifyListeners();
      return 'error';
    }
  }

  /// Get the default offering for display in paywall
  Offering? get currentOffering {
    return _offerings?.current;
  }

  /// Get monthly package from current offering
  Package? get monthlyPackage {
    return currentOffering?.monthly;
  }

  /// Get yearly package from current offering
  Package? get yearlyPackage {
    return currentOffering?.annual;
  }

  /// Purchase a specific package
  Future<bool> purchasePackage(Package package) async {
    if (!_isConfigured) {
      debugPrint('RevenueCat not configured, cannot purchase');
      return false;
    }
    
    try {
      _customerInfo = await Purchases.purchasePackage(package);
      _updateProStatus(_customerInfo);
      return _isPro;
    } catch (e) {
      debugPrint('Purchase error: $e');
      return false;
    }
  }

  /// Get expiration date for subscription (if any)
  String? get expirationDate {
    final entitlement = _customerInfo?.entitlements.active[_proEntitlement];
    return entitlement?.expirationDate;
  }
  /// DEBUG ONLY: Manually toggle PRO status
  void debugSetProStatus(bool status) async {
    _isPro = status;
    notifyListeners();

    // Cache the debug status so it persists across hot restarts/app restarts
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_pro_version', _isPro);
      
      // Clear analysis caches to reset state for testing
      await prefs.remove('last_analysis_result');
      await prefs.remove('last_analysis_date');
      await prefs.remove('last_moon_sync_result');
      await prefs.remove('last_moon_sync_date');
      
      debugPrint('DEBUG: Manually set PRO status to $_isPro and cleared analysis cache.');
    } catch (e) {
      debugPrint('Cache error: $e');
    }
  }
}
