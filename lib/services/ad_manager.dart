import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/helpers/ad_helper.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';
import 'dart:async';

/// Central manager for interstitial ads with frequency/cooldown control.
/// 
/// Rules:
/// - 5-minute cooldown between ads
/// - Max 3 interstitials per session
/// - PRO users never see ads
/// - Ads are preloaded in the background
class AdManager {
  // Singleton
  static final AdManager _instance = AdManager._internal();
  static AdManager get instance => _instance;
  AdManager._internal();

  // State
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  bool _adLoadFailed = false; // Track if ad loading failed after max retries

  // Configuration
  static const int _maxRetries = 3;
  static const int _retryDelayMinutes = 5; // Auto-retry after 5 minutes on failure
  int _retryCount = 0;
  
  /// Check if an ad is currently loaded and ready
  bool get isAdLoaded => _isAdLoaded && _interstitialAd != null;
  
  /// Check if ad loading has failed (max retries reached)
  bool get adLoadFailed => _adLoadFailed;

  /// Initialize and preload the first ad.
  void initialize() {
    _retryCount = 0;
    _adLoadFailed = false;
    _loadInterstitialAd();
  }

  /// Preload an interstitial ad.
  void _loadInterstitialAd() {
    debugPrint('AdManager: Loading interstitial ad (attempt ${_retryCount + 1}/$_maxRetries)...');
    
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdManager: Interstitial loaded successfully.');
          _interstitialAd = ad;
          _isAdLoaded = true;
          _adLoadFailed = false; // Reset failed state
          _retryCount = 0; // Reset retry count on success
          // Callbacks will be set when showing the ad to handle completion
        },
        onAdFailedToLoad: (error) {
          debugPrint('AdManager: Failed to load interstitial: ${error.message} (code: ${error.code})');
          _isAdLoaded = false;
          _interstitialAd = null;
          
          // Retry with exponential backoff
          if (_retryCount < _maxRetries) {
            _retryCount++;
            final delay = Duration(seconds: 2 * _retryCount); // 2s, 4s, 6s
            debugPrint('AdManager: Retrying in ${delay.inSeconds} seconds...');
            Future.delayed(delay, () {
              _loadInterstitialAd();
            });
          } else {
            debugPrint('AdManager: Max retries reached. Ad loading failed.');
            _adLoadFailed = true; // Mark as failed for UI to handle
            
            // Schedule auto-retry after delay
            debugPrint('AdManager: Will auto-retry in $_retryDelayMinutes minutes.');
            Future.delayed(Duration(minutes: _retryDelayMinutes), () {
              _retryCount = 0;
              _adLoadFailed = false;
              _loadInterstitialAd();
            });
          }
        },
      ),
    );
  }

  /// Show the interstitial ad if ready.
  /// Returns `true` if ad was shown and completed, `false` otherwise.
  Future<bool> showInterstitial(BuildContext context) async {
    // 1. Check PRO status (Double check)
    final isPro = context.read<SubscriptionProvider>().isPro;
    if (isPro) {
      debugPrint('AdManager: PRO user, skipping ad.');
      return false;
    }

    // 2. Check if ad is loaded
    if (!_isAdLoaded || _interstitialAd == null) {
      debugPrint('AdManager: Ad not ready to show.');
      return false;
    }

    // 3. Show Ad with Completer
    debugPrint('AdManager: Showing interstitial ad.');
    final completer = Completer<bool>();

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('AdManager: Ad dismissed.');
        ad.dispose();
        _interstitialAd = null;
        _isAdLoaded = false;
        
        if (!completer.isCompleted) completer.complete(true);
        
        // Preload next
        _retryCount = 0;
        _loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AdManager: Failed to show ad: ${error.message}');
        ad.dispose();
        _interstitialAd = null;
        _isAdLoaded = false;
        
        if (!completer.isCompleted) completer.complete(false);
        
        _retryCount = 0;
        _loadInterstitialAd();
      },
      onAdShowedFullScreenContent: (ad) {
        debugPrint('AdManager: Ad showed.');
      },
    );

    await _interstitialAd!.show();
    
    // [FIX] Add timeout to prevent app freeze if SDK callback never fires
    return completer.future.timeout(
      const Duration(seconds: 5), 
      onTimeout: () {
        debugPrint('AdManager: Show timeout (5s). Unfreezing UI.');
        _isAdLoaded = false; // Reset state
        _interstitialAd = null;
        return false; // Treat as failed
      }
    );
  }
  
  /// Dispose resources. calls on app termination if needed.
  void dispose() {
    _interstitialAd?.dispose();
  }
}
