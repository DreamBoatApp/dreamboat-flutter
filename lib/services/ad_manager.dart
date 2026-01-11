import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/helpers/ad_helper.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';

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
  DateTime? _lastAdShownTime;
  int _adsShownThisSession = 0;

  // Configuration
  static const int maxAdsPerSession = 20; // Increased to effectively allow "every time"
  static const Duration cooldownDuration = Duration(seconds: 0); // Removed cooldown

  /// Initialize and preload the first ad.
  /// Call this early in app lifecycle (e.g., main.dart).
  void initialize() {
    _loadInterstitialAd();
  }

  /// Preload an interstitial ad.
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdManager: Interstitial loaded.');
          _interstitialAd = ad;
          _isAdLoaded = true;

          // Set up callbacks
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('AdManager: Ad dismissed.');
              ad.dispose();
              _interstitialAd = null;
              _isAdLoaded = false;
              // Preload next
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('AdManager: Failed to show ad: ${error.message}');
              ad.dispose();
              _interstitialAd = null;
              _isAdLoaded = false;
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('AdManager: Failed to load interstitial: ${error.message}');
          _isAdLoaded = false;
        },
      ),
    );
  }

  /// Attempt to show an interstitial ad if conditions are met.
  /// 
  /// Returns `true` if an ad was shown, `false` otherwise.
  /// 
  /// Conditions:
  /// 1. User is NOT PRO.
  /// 2. Cooldown has passed (5 minutes since last ad).
  /// 3. Session limit not reached (max 3).
  /// 4. Ad is loaded.
  Future<bool> maybeShowInterstitial(BuildContext context) async {
    // 1. Check PRO status
    final isPro = context.read<SubscriptionProvider>().isPro;
    if (isPro) {
      debugPrint('AdManager: PRO user, skipping ad.');
      return false;
    }

    // 2. Check session limit
    if (_adsShownThisSession >= maxAdsPerSession) {
      debugPrint('AdManager: Session limit reached ($_adsShownThisSession/$maxAdsPerSession).');
      return false;
    }

    // 3. Check cooldown
    if (_lastAdShownTime != null) {
      final timeSinceLastAd = DateTime.now().difference(_lastAdShownTime!);
      if (timeSinceLastAd < cooldownDuration) {
        debugPrint('AdManager: Cooldown active (${timeSinceLastAd.inSeconds}s < ${cooldownDuration.inSeconds}s).');
        return false;
      }
    }

    // 4. Check if ad is loaded
    if (!_isAdLoaded || _interstitialAd == null) {
      debugPrint('AdManager: Ad not ready.');
      return false;
    }

    // All checks passed, show ad
    debugPrint('AdManager: Showing interstitial ad.');
    await _interstitialAd!.show();
    _lastAdShownTime = DateTime.now();
    _adsShownThisSession++;
    return true;
  }

  /// Dispose resources. Call on app termination if needed.
  void dispose() {
    _interstitialAd?.dispose();
  }
}
