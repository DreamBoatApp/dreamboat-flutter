import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dream_boat_mobile/widgets/custom_button.dart';
import 'package:dream_boat_mobile/widgets/platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/services/connectivity_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';

class ProUpgradeDialog extends StatefulWidget {
  const ProUpgradeDialog({super.key});

  @override
  State<ProUpgradeDialog> createState() => _ProUpgradeDialogState();
}

class _ProUpgradeDialogState extends State<ProUpgradeDialog> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _isYearlySelected = true; // Default to yearly (better value)
  late AnimationController _shimmerController;

  // =============================================================
  // WELCOME OFFER BEHAVIOR TABLE (KİLİT)
  // =============================================================
  // Platform | Intro Var mı? | Label                        | Timer
  // ---------+---------------+------------------------------+------
  // iOS      | introDiscount | "İlk abone özel teklifi"     | ❌
  // iOS      | null          | ❌ Hiçbir offer (standart)   | ❌
  // Android  | N/A           | Standart PRO ekranı          | ❌
  // =============================================================

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _handlePurchase(bool isYearly) async {
    // REMOVED: ConnectivityService pre-check - iOS unreliable
    // RevenueCat SDK handles offline state and will show appropriate error

    final provider = context.read<SubscriptionProvider>();
    final package = isYearly ? provider.yearlyPackage : provider.monthlyPackage;
    
    if (package == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscription packages not available'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          )
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final success = await provider.purchasePackage(package);
      
      if (mounted) {
        if (success) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => _ProSuccessDialog(),
          );
          if (mounted) {
            Navigator.pop(context, true);
          }
        } else {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      debugPrint('Purchase error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleRestore() async {
    setState(() => _isLoading = true);
    final provider = context.read<SubscriptionProvider>();
    final t = AppLocalizations.of(context)!;
    
    try {
      final result = await provider.restorePurchases();
      
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      if (result == 'success') {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text(t.restoreSuccess),
               backgroundColor: Colors.green,
               behavior: SnackBarBehavior.floating,
             )
           );
           Navigator.pop(context, true);
        }
      } else {
        String message;
        switch (result) {
          case 'not_found':
            message = t.restoreNotFound;
            break;
          case 'not_configured':
          case 'unavailable':
            message = t.restoreUnavailable;
            break;
          default:
            message = t.restoreError;
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            )
          );
        }
      }
    } catch (e) {
      debugPrint('Restore error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.restoreError),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          )
        );
      }
    }
  }

  void _openLegalUrl(BuildContext context, String type) async {
    final locale = Localizations.localeOf(context).languageCode;
    // Map locale to supported URL paths, default to 'en'
    final supportedLocales = ['en', 'tr', 'es', 'de', 'fr', 'pt', 'it'];
    final urlLocale = supportedLocales.contains(locale) ? locale : 'en';
    
    final path = type == 'privacy' ? 'privacy' : 'terms';
    final url = Uri.parse('https://www.novabloomstudio.com/$urlLocale/$path');
    
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final provider = context.watch<SubscriptionProvider>();
    
    // Determine price display state
    final bool isLoadingPrices = provider.isConfiguring || 
        (!provider.isConfigured && !provider.offeringsLoadFailed);
    final bool pricesLoadFailed = provider.offeringsLoadFailed;
    
    // Get prices and trial info from RevenueCat offerings with smart fallback
    String monthlyPrice;
    String yearlyPrice;
    
    if (provider.monthlyPackage != null) {
      monthlyPrice = provider.monthlyPackage!.storeProduct.priceString;
    } else if (isLoadingPrices) {
      monthlyPrice = t.priceLoading;
    } else if (pricesLoadFailed) {
      monthlyPrice = t.priceLoadError;
    } else {
      monthlyPrice = t.priceLoading; // Fallback
    }
    
    if (provider.yearlyPackage != null) {
      yearlyPrice = provider.yearlyPackage!.storeProduct.priceString;
    } else if (isLoadingPrices) {
      yearlyPrice = t.priceLoading;
    } else if (pricesLoadFailed) {
      yearlyPrice = t.priceLoadError;
    } else {
      yearlyPrice = t.priceLoading; // Fallback
    }
    
    // Check for free trial (introductory offer)
    final yearlyIntro = provider.yearlyPackage?.storeProduct.introductoryPrice;
    final monthlyIntro = provider.monthlyPackage?.storeProduct.introductoryPrice;
    
    // DEBUG: Log what RevenueCat returns
    debugPrint('=== REVENUECAT TRIAL DEBUG ===');
    debugPrint('Yearly Package: ${provider.yearlyPackage?.storeProduct.identifier}');
    debugPrint('Yearly Intro: $yearlyIntro');
    debugPrint('Yearly Intro Price: ${yearlyIntro?.price}');
    debugPrint('Yearly Intro Cycles: ${yearlyIntro?.cycles}');
    debugPrint('Yearly Intro Period: ${yearlyIntro?.periodNumberOfUnits} ${yearlyIntro?.periodUnit}');
    debugPrint('Monthly Intro: $monthlyIntro');
    debugPrint('==============================');
    
    // Helper to robustly calculate days from period unit
    int calculateDays(IntroductoryPrice? discount) {
      if (discount == null || discount.price != 0) return 0;
      
      final units = discount.periodNumberOfUnits;
      // Convert to string and upper case to handle Enums or Strings (Week, WEEK, PeriodUnit.week)
      final unit = discount.periodUnit.toString().toUpperCase(); 
      
      int daysPerUnit = 0;
      if (unit.contains('DAY')) daysPerUnit = 1;
      else if (unit.contains('WEEK')) daysPerUnit = 7;
      else if (unit.contains('MONTH')) daysPerUnit = 30;
      else if (unit.contains('YEAR')) daysPerUnit = 365;
      
      return units * daysPerUnit;
    }

    final yearlyTrialDays = calculateDays(yearlyIntro);
    final monthlyTrialDays = calculateDays(monthlyIntro);
    
    debugPrint('Calculated Trial Days - Yearly: $yearlyTrialDays, Monthly: $monthlyTrialDays, Unit: ${yearlyIntro?.periodUnit}');

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F0F23), // Deep void
                  Color(0xFF16163F), // Dark navy
                  Color(0xFF1a1a2e), // Lighter indigo
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4C1D95).withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  // Star field background
                  CustomPaint(
                    size: const Size(double.infinity, 600),
                    painter: _StarFieldPainter(),
                  ),
                  
                  // Content
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header with boat icon inline
                          AnimatedBuilder(
                            animation: _shimmerController,
                            builder: (context, child) {
                              return ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: const [
                                      Color(0xFFFBBF24),
                                      Color(0xFFFFE082),
                                      Color(0xFFFBBF24),
                                    ],
                                    stops: [
                                      (_shimmerController.value - 0.3).clamp(0.0, 1.0),
                                      _shimmerController.value,
                                      (_shimmerController.value + 0.3).clamp(0.0, 1.0),
                                    ],
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.srcIn,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "DreamBoat PRO ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/images/db_logo_icon.png',
                                      color: const Color(0xFFFBBF24),
                                      width: 36,
                                      height: 36,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          
                          const SizedBox(height: 24),

                          // Side-by-side pricing cards with centered badge
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Row(
                                children: [
                                  // Monthly Card
                                  Expanded(
                                    child: _buildPricingCard(
                                      title: t.planMonthly,
                                      price: monthlyPrice,
                                      billingInfo: t.billingMonthly,
                                      isPopular: false,
                                      isSelected: !_isYearlySelected,
                                      onTap: () => setState(() => _isYearlySelected = false),
                                      onSubscribe: () => _handlePurchase(false),
                                      subscribeText: t.subscribeNow,
                                    ),
                                  ),
                                  
                                  const SizedBox(width: 12),
                                  
                                  // Annual Card
                                  Expanded(
                                    child: _buildPricingCard(
                                      title: t.planAnnual,
                                      price: yearlyPrice,
                                      billingInfo: t.billingAnnual,
                                      isPopular: true,
                                      popularLabel: t.mostPopular,
                                      // iOS: Only show intro label if RC has introductory discount
                                      // Android: Standard PRO screen (no special offer)
                                      discountLabel: Platform.isIOS
                                          ? (yearlyIntro != null ? t.welcomeOfferFirstTime : t.discountPercent)
                                          : t.discountPercent,
                                      isSelected: _isYearlySelected,
                                      onTap: () => setState(() => _isYearlySelected = true),
                                      onSubscribe: () => _handlePurchase(true),
                                      subscribeText: t.subscribeNow,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 28),
                          
                          // Show Retry button if prices failed, otherwise show Free Trial Badge
                          if (pricesLoadFailed)
                            Center(
                              child: TextButton.icon(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  provider.retryLoadOfferings();
                                },
                                icon: Icon(
                                  LucideIcons.refreshCw,
                                  size: 16,
                                  color: const Color(0xFFFBBF24).withOpacity(0.8),
                                ),
                                label: Text(
                                  t.priceRetryButton,
                                  style: TextStyle(
                                    color: const Color(0xFFFBBF24).withOpacity(0.8),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  backgroundColor: const Color(0xFFFBBF24).withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: const Color(0xFFFBBF24).withOpacity(0.3),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else if (isLoadingPrices)
                            Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: PlatformWidgets.activityIndicator(
                                  color: const Color(0xFF3EE6C4).withOpacity(0.7),
                                  radius: 10,
                                ),
                              ),
                            )
                          else
                            // Free Trial Badge - subtle, smaller than main badges
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  // Subtle glass effect
                                  color: const Color(0xFF3EE6C4).withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF3EE6C4).withOpacity(0.30),
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  t.freeTrialBadge,
                                  style: TextStyle(
                                    color: const Color(0xFF3EE6C4).withOpacity(0.85),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ),
                          
                          const SizedBox(height: 18),

                          // PRO Features with descriptions (no icons)
                          _buildFeatureWithSubtitle(
                            title: t.proFeatureAdsTitle,
                            subtitle: t.proFeatureAdsSubtitle,
                          ),
                          _buildFeatureWithSubtitle(
                            title: t.proFeatureCosmicTitle,
                            subtitle: t.proFeatureCosmicSubtitle,
                          ),
                          _buildFeatureWithSubtitle(
                            title: t.proFeatureImageGenTitle,
                            subtitle: t.proFeatureImageGenSubtitle,
                          ),
                          _buildFeatureWithSubtitle(
                            title: t.proFeatureAnalysisTitle,
                            subtitle: t.proFeatureAnalysisSubtitle,
                          ),
                          _buildFeatureWithSubtitle(
                            title: t.moonSyncTitle,
                            subtitle: t.moonSyncDescriptionShort,
                          ),
                          _buildFeatureWithSubtitle(
                            title: t.proFeatureGuideTitle,
                            subtitle: t.proFeatureGuideSubtitle,
                          ),

                          const SizedBox(height: 20),
                          
                          // Main Subscribe Button
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFBBF24).withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                _handlePurchase(_isYearlySelected);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFBBF24),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: _buildSubscribeButtonContent(
                                isYearly: _isYearlySelected,
                                yearlyTrialDays: yearlyTrialDays,
                                monthlyTrialDays: monthlyTrialDays,
                                yearlyPrice: yearlyPrice,
                                monthlyPrice: monthlyPrice,
                                t: t,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),
                          
                          // Maybe later button
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: const Size(48, 48),
                              tapTargetSize: MaterialTapTargetSize.padded,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Navigator.pop(context);
                            },
                            child: Text(
                              t.upgradeCancel, 
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4), 
                                fontSize: 14,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),

                          // Restore Purchase Button
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: const Size(48, 36),
                              tapTargetSize: MaterialTapTargetSize.padded,
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _handleRestore();
                            },
                            child: Text(
                              t.settingsRestorePurchases,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Legal links row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => _openLegalUrl(context, 'privacy'),
                                child: Text(
                                  t.privacyPolicyLink,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.35),
                                    fontSize: 11,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white.withOpacity(0.35),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  '|',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.2),
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _openLegalUrl(context, 'terms'),
                                child: Text(
                                  t.termsOfUseLink,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.35),
                                    fontSize: 11,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white.withOpacity(0.35),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // X Close Button at top right
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.white.withOpacity(0.15),
                highlightColor: Colors.white.withOpacity(0.08),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
          
          // Loading overlay
          if (_isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: PlatformWidgets.activityIndicator(
                    color: const Color(0xFFFBBF24),
                    radius: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required String billingInfo,
    required bool isPopular,
    String? popularLabel,
    String? discountLabel,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback onSubscribe,
    required String subscribeText,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.only(top: 16, left: 12, right: 12, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected 
            ? Colors.white.withOpacity(0.1) 
            : Colors.white.withOpacity(0.03),
          border: Border.all(
            color: isSelected 
              ? const Color(0xFFFBBF24).withOpacity(0.5) 
              : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Price
                Text(
                  price,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFFFBBF24) : Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Subscribe button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onSubscribe();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected 
                        ? const Color(0xFFFBBF24) 
                        : Colors.white.withOpacity(0.1),
                      foregroundColor: isSelected ? Colors.black : Colors.white70,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      subscribeText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Billing info
                Text(
                  billingInfo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 9,
                    height: 1.3,
                  ),
                ),
                
                // Space for discount badge below
                if (discountLabel != null)
                  const SizedBox(height: 8),
              ],
            ),
            
            // Popular badge (top)
            if (isPopular && popularLabel != null)
              Positioned(
                top: -24,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      popularLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            
            // Discount badge (bottom)
            if (discountLabel != null)
              Positioned(
                bottom: -28,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(0.55),
                          blurRadius: 12,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Text(
                      discountLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscribeButtonContent({
    required bool isYearly,
    required int yearlyTrialDays,
    required int monthlyTrialDays,
    required String yearlyPrice,
    required String monthlyPrice,
    required AppLocalizations t,
  }) {
    final trialDays = isYearly ? yearlyTrialDays : monthlyTrialDays;
    final price = isYearly ? yearlyPrice : monthlyPrice;
    final subscribeText = isYearly ? t.subscribeYearly : t.subscribeMonthly;
    
    // Check if price is an error state
    final bool isPriceError = price == t.priceLoadError || price == t.priceLoading;
    
    // Android-specific: Always show trial format when price is valid
    // Use 7 days default if no trial info from RevenueCat
    if (Platform.isAndroid && !isPriceError) {
      final displayTrialDays = trialDays > 0 ? trialDays : 7;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$displayTrialDays ${t.freeTrialDays}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${t.then} ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ],
      );
    }
    
    // iOS or when trialDays > 0 (original behavior)
    if (trialDays > 0) {
      // Show trial info with strikethrough price
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$trialDays ${t.freeTrialDays}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Align text baselines
            children: [
              Text(
                '${t.then} ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold, // Make price stand out
                  color: Colors.black, // Full black for clarity
                  decoration: TextDecoration.none, // Explicitly no strikethrough
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // No trial - show regular text (iOS only, or error states)
      // If price failed to load, show only the error message (not combined with subscribe text)
      return Text(
        isPriceError ? price : '$subscribeText $price',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Widget _buildFeatureWithSubtitle({
    required String title,
    required String subtitle,
  }) {
    // Fixed height for consistent card sizing
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        height: 125, // Fixed height for ALL cards
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withOpacity(0.05),
            border: Border.all(
              color: const Color(0xFFFBBF24).withOpacity(0.3), // Gold border
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title, 
                style: const TextStyle(
                  color: Color(0xFFFBBF24), 
                  fontWeight: FontWeight.w600, 
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle, 
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6), 
                  fontSize: 12,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Star field painter with cached positions
class _StarFieldPainter extends CustomPainter {
  // Static cached star data to prevent regeneration on rebuild
  static List<_StarData>? _cachedStars;
  
  static List<_StarData> _generateStars() {
    if (_cachedStars != null) return _cachedStars!;
    
    final random = Random(42);
    _cachedStars = List.generate(40, (i) {
      return _StarData(
        xPercent: random.nextDouble(),
        yPercent: random.nextDouble(),
        radius: random.nextDouble() * 1.2 + 0.5,
        opacity: random.nextDouble() * 0.4 + 0.1,
        hasGlow: random.nextDouble() > 0.8,
      );
    });
    return _cachedStars!;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final stars = _generateStars();
    
    for (final star in stars) {
      final x = star.xPercent * size.width;
      final y = star.yPercent * size.height;
      
      final starPaint = Paint()
        ..color = Colors.white.withOpacity(star.opacity)
        ..style = PaintingStyle.fill;

      if (star.hasGlow) {
         canvas.drawCircle(
           Offset(x, y), 
           star.radius * 2.5, 
           Paint()..color = Colors.white.withOpacity(0.05)
         );
      }
      
      canvas.drawCircle(Offset(x, y), star.radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StarData {
  final double xPercent;
  final double yPercent;
  final double radius;
  final double opacity;
  final bool hasGlow;
  
  const _StarData({
    required this.xPercent,
    required this.yPercent,
    required this.radius,
    required this.opacity,
    required this.hasGlow,
  });
}

// Celebratory Success Dialog after PRO purchase
class _ProSuccessDialog extends StatefulWidget {
  @override
  State<_ProSuccessDialog> createState() => _ProSuccessDialogState();
}

class _ProSuccessDialogState extends State<_ProSuccessDialog> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _opacityAnimation.value,
        child: Transform.scale(
          scale: _scaleAnimation.value,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1a1a2e),
                    Color(0xFF16213e),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFFFBBF24).withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFBBF24).withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Welcome Message
                  Text(
                    t.upgradeSuccess,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Golden Start Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBBF24),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(48, 48),
                        tapTargetSize: MaterialTapTargetSize.padded,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0xFFFBBF24).withOpacity(0.5),
                      ),
                      child: Text(
                        t.upgradeStart,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
