import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dream_boat_mobile/widgets/background_sky.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/screens/new_dream_screen.dart';
import 'package:dream_boat_mobile/screens/journal_screen.dart';
import 'package:dream_boat_mobile/screens/stats_screen.dart';
import 'package:dream_boat_mobile/screens/guide_screen.dart';
import 'package:dream_boat_mobile/screens/settings_screen.dart';
import 'package:dream_boat_mobile/widgets/glass_bento.dart';
import 'package:dream_boat_mobile/widgets/particle_overlay.dart';
import 'package:dream_boat_mobile/widgets/home_previews.dart'; // [NEW] Impact
import 'package:dream_boat_mobile/widgets/pro_badge.dart';
import 'package:dream_boat_mobile/widgets/pro_upgrade_dialog.dart'; // [NEW]
import 'package:dream_boat_mobile/widgets/language_selector_modal.dart';
import 'package:dream_boat_mobile/utils/custom_page_route.dart'; // [NEW]
import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';
import 'package:dream_boat_mobile/widgets/dreamboat_logo.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart'; // For SystemNavigator

import 'package:dream_boat_mobile/services/notification_service.dart';
import 'package:dream_boat_mobile/services/biometric_service.dart';
import 'package:dream_boat_mobile/widgets/biometric_prompt_modal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dream_boat_mobile/services/review_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _lastBackPressTime;
  
  @override
  void initState() {
    super.initState();
    // Track daily login and check for 3-day streak to trigger review
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ReviewService.recordLoginAndCheckStreak(context);
    });
  }


  /// Opens the Journal screen with biometric authentication check
  Future<void> _openJournal(BuildContext context, AppLocalizations t) async {
    // First time? Show the prompt modal
    if (!await BiometricService.hasShownBiometricPrompt()) {
      final wantsLock = await showBiometricPromptModal(context);
      if (wantsLock == true) {
        // User wants to enable lock, try to authenticate
        final success = await BiometricService.authenticate(t.biometricLockReason);
        if (success) {
          await BiometricService.setJournalLockEnabled(true);
        }
      }
      await BiometricService.setShownBiometricPrompt();
    }
    
    // If lock is enabled, require authentication
    if (await BiometricService.isJournalLockEnabled()) {
      final authenticated = await BiometricService.authenticate(t.biometricLockReason);
      if (!authenticated) {
        // Authentication failed, don't navigate
        return;
      }
    }
    
    // Navigate to journal
    if (context.mounted) {
      Navigator.push(context, FastSlidePageRoute(child: const JournalScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isPro = context.watch<SubscriptionProvider>().isPro;
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        
        final now = DateTime.now();
        final backButtonHasNotBeenPressedOrDoublePressed = 
            _lastBackPressTime == null || 
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2);
        
        if (backButtonHasNotBeenPressedOrDoublePressed) {
          _lastBackPressTime = now;
          final t = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                t.pressBackToExit,
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF1E1B4B),
            ),
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: NightSkyBackground(
        isPro: isPro,
        child: Stack(
        children: [
          // 1. Ambient Particles
          const ParticleOverlay(particleCount: 20, color: Colors.white),


          // 2. Main Content
          Scaffold(
            backgroundColor: Colors.transparent, // Important transparency
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(), // Changed from NeverScrollable for small screen compatibility
                padding: const EdgeInsets.fromLTRB(20, 33, 20, 40),
                child: Stack(
                  children: [
                    Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // HERO SECTION REMOVED
                    const SizedBox(height: 12), // Push header down slightly
                    
                    // Title with Boat Icon and Globe
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Menu Icon (left-aligned)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                               Navigator.push(context, FastSlidePageRoute(child: const SettingsScreen()));
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              child: Icon(
                                LucideIcons.menu,
                                color: Colors.white.withOpacity(0.8),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        // Expanded center section for title AND subtitle
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "DreamBoat",
                                    style: GoogleFonts.quicksand(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold, 
                                      color: isPro ? const Color(0xFFFBBF24) : const Color(0xFFE8ECFF), // Soft lavender-white
                                      letterSpacing: 0.5
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Image.asset(
                                    'assets/images/db_logo_icon.png',
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.contain,
                                    color: isPro ? const Color(0xFFFBBF24) : const Color(0xFFE8ECFF),
                                  ),
                                  if (isPro) ...[
                                    const SizedBox(width: 8),
                                    const ProBadge()
                                  ]
                                ],
                              ),
                              Text(
                                t.homeSubtitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Quicksand',
                                  color: const Color(0xFFB0B8D4), // Soft muted blue
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Language Code (right-aligned)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (ctx) => const LanguageSelectorModal(),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              child: Text(
                                Localizations.localeOf(context).languageCode.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 81), // Reduced by 12 to compensate for header spacing
                    
                    // GRID LAYOUT (V3 Specification)
                    
                    // Row 1: New Dream (Full Width, Horizontal)
                    GlassBento(
                      height: 120,
                      onTap: () => Navigator.push(context, FastSlidePageRoute(child: const NewDreamScreen())),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            t.homeNewDream,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Icon(LucideIcons.arrowRight, color: Colors.white.withValues(alpha: 0.5), size: 18),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Row 2: Journal | Stats
                    Row(
                      children: [
                        Expanded(
                          child: BentoItem(
                            height: 180,
                            title: t.homeJournal,
                            background: const CalendarPreview(),
                            content: null,
                            onTap: () => _openJournal(context, t),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: BentoItem(
                            height: 180,
                            title: t.homeStats,
                            background: const StatsPreview(),
                            content: null,
                            onTap: () => Navigator.push(context, FastSlidePageRoute(child: const StatsScreen())),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Row 3: Guide (Full Width) - Centered title
                    GlassBento(
                      height: 230,
                      padding: EdgeInsets.zero,
                      onTap: () => Navigator.push(context, FastSlidePageRoute(child: const GuideScreen())),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              "assets/images/milky_way_v2.png",
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              color: Colors.black.withValues(alpha: 0.3),
                              colorBlendMode: BlendMode.darken,
                            ),
                          ),
                          // Centered Title with Glow
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFBBF24).withOpacity(0.20),
                                    blurRadius: 25,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    t.homeGuide,
                                    style: TextStyle(
                                      color: isPro ? const Color(0xFFFBBF24) : Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      shadows: const [Shadow(color: Colors.black45, blurRadius: 4)]
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  if (!isPro)
                                     const ProBadge(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    

                  ],
                ),
              ],
            ),
              ),
            ),
          ),
        ],
      ),
     ),
    );
  }
}




