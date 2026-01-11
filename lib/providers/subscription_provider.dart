import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionProvider extends ChangeNotifier {
  bool _isPro = false;
  bool _isLoading = true; // Initial load
  bool _isRestoring = false; // For manual restore

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  static const String _proProductId = 'dream_boat_pro';

  bool get isPro => _isPro;
  bool get isLoading => _isLoading;
  bool get isRestoring => _isRestoring;

  SubscriptionProvider() {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    // 1. Load Cache (Optimistic / Fail Open)
    final prefs = await SharedPreferences.getInstance();
    _isPro = prefs.getBool('is_pro_version') ?? false;
    _isLoading = false;
    notifyListeners();

    // 2. Initialize Store Connection & Restore
    // If store is unavailable, we keep the cached state (Fail Open).
    final available = await _iap.isAvailable();
    if (available) {
      final purchaseUpdated = _iap.purchaseStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (error) {
        // Stream error: Keep cached state.
        debugPrint("Purchase Stream Error: $error");
      });
      
      try {
        await _iap.restorePurchases();
      } catch (e) {
        // Network/Restore error: Keep cached state.
        debugPrint("Restore Purchases Error: $e");
      }
    }
  }
  
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    bool foundPro = false;

    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased || 
          purchaseDetails.status == PurchaseStatus.restored) {
        
        if (purchaseDetails.productID == _proProductId) {
          foundPro = true;
        }
      }
      
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    }
    
    // STRICT SYNC:
    // If we received an update list (from restore or purchase), and PRO is present -> Enable.
    // If PRO is NOT present -> Disable (Downgrade).
    // This assumes the list from restorePurchases is comprehensive for active entitlements.
    if (foundPro) {
      await _enablePro();
    } else {
      // Only downgrade if the list didn't contain pending items (which might resolve to true later)
      // or if we are confident. For 'restorePurchases', an empty list means no items.
      // We will downgrade to ensure "Store is Truth".
      await _disablePro();
    }
  }
  
  Future<void> _enablePro() async {
    if (_isPro) return; // Already enabled
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_pro_version', true);
    _isPro = true;
    notifyListeners();
  }

  Future<void> _disablePro() async {
    if (!_isPro) return; // Already disabled
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_pro_version', false);
    _isPro = false;
    notifyListeners();
  }

  // Debug functionality
  Future<void> purchasePro() async {
     await _enablePro();
  }

  Future<void> restoreStandard() async {
    await _disablePro();
  }

  /// User-triggered restore purchases functionality (required for App Store)
  /// Returns: 'success' if PRO was restored, 'not_found' if no purchases found, 'error' on failure
  Future<String> restorePurchases() async {
    _isRestoring = true;
    notifyListeners();

    try {
      final available = await _iap.isAvailable();
      if (!available) {
        _isRestoring = false;
        notifyListeners();
        return 'unavailable';
      }

      await _iap.restorePurchases();
      
      // Wait a bit for the purchase stream to process
      await Future.delayed(const Duration(seconds: 2));
      
      _isRestoring = false;
      notifyListeners();
      
      // Return based on current PRO status after restore
      return _isPro ? 'success' : 'not_found';
    } catch (e) {
      debugPrint("Manual Restore Purchases Error: $e");
      _isRestoring = false;
      notifyListeners();
      return 'error';
    }
  }
  
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
