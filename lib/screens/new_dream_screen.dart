import 'dart:ui'; // Needed for ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // [NEW] For SystemChannels
import 'package:lucide_icons/lucide_icons.dart';

import 'package:dream_boat_mobile/theme/app_theme.dart';
import 'package:dream_boat_mobile/widgets/background_sky.dart';
import 'package:dream_boat_mobile/services/connectivity_service.dart'; 
import 'package:dream_boat_mobile/widgets/glass_card.dart';
import 'package:dream_boat_mobile/widgets/custom_button.dart';
import 'package:dream_boat_mobile/widgets/mood_selection_sheet.dart';
import 'package:dream_boat_mobile/widgets/ad_consent_dialog.dart'; // [NEW]
import 'package:dream_boat_mobile/widgets/dream_analysis_overlay.dart'; // [NEW]
import 'package:dream_boat_mobile/widgets/pro_upgrade_dialog.dart'; // [NEW] For Pro flow

import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/services/openai_service.dart';
import 'package:dream_boat_mobile/services/dream_service.dart';
import 'package:dream_boat_mobile/services/ad_manager.dart';
import 'package:dream_boat_mobile/services/astronomy_service.dart'; // [NEW]
import 'package:dream_boat_mobile/models/dream_entry.dart';
import 'package:dream_boat_mobile/screens/journal_screen.dart';
import 'package:dream_boat_mobile/widgets/gradient_text.dart';
import 'package:dream_boat_mobile/utils/custom_page_route.dart'; 

import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewDreamScreen extends StatefulWidget {
  const NewDreamScreen({super.key});

  @override
  State<NewDreamScreen> createState() => _NewDreamScreenState();
}

class _NewDreamScreenState extends State<NewDreamScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // [NEW] Focus Control
  bool _isSaving = false;
  bool _isModalOpen = false; // [NEW] To prevent scaffold resize
  bool _isAdDialogOpen = false; // [NEW] To prevent premature unlock
  int? _rateLimitMinutes; // [NEW] Rate limit countdown minutes
  bool _showAnalysisOverlay = false; // [NEW] Analysis overlay visibility
  bool _preparingAd = false; // [NEW] Transition state for ad loading
  // [REMOVED] _weeklyUsage - Weekly limit disabled for unlimited free interpretations

  @override
  void initState() {
    super.initState();
    // [REMOVED] _loadUsage() - Weekly limit disabled
  }


  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSave() {
    _focusNode.unfocus(); // Close keyboard
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    // Validation: Allow short dreams, but they won't be interpreted.
    _showMoodModal();
  }

  void _showMoodModal() {
    setState(() => _isModalOpen = true); // Lock layout
    
    // Aggressive keyboard dismissal for Android 12+ compatibility
    _focusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MoodSelectionSheet(
        onSave: (mood, secondaryMoods, intensity, vividness) {
           _checkAdAndProcess(mood, secondaryMoods, intensity, vividness);
        }
      ),
    ).whenComplete(() {
       // Only unlock if we are NOT opening the ad dialog (or it's already open via checks)
       if (mounted && !_isAdDialogOpen) {
         setState(() => _isModalOpen = false);
         _focusNode.unfocus();
       }
    });
  }
  
  Future<void> _checkAdAndProcess(String mood, List<String> secondaryMoods, int intensity, int vividness) async {
    if (_isSaving) return; // Prevent double taps

    // Lock everything down - aggressive keyboard dismissal
    _focusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    // 0. Check Connectivity (Safety First)
    bool isOnline = false;
    try {
      // Short timeout to prevent UI freeze
      isOnline = await ConnectivityService.isConnected.timeout(const Duration(seconds: 3));
    } catch (e) {
      debugPrint('Connectivity check failed: $e');
      isOnline = false; // Fallback to offline on sensitive networks
    }

    if (!mounted) return;

    if (!isOnline) {
       // [NEW] Offline: Show explicit "No Internet" dialog
       await _showOfflineDialog(mood, secondaryMoods, intensity, vividness);
       return;
    }

    // 1. Check PRO Status
    final isPro = context.read<SubscriptionProvider>().isPro;
    if (isPro) {
      if (mounted) Navigator.pop(context); // Close Mood Sheet
      await _processDream(mood, secondaryMoods, intensity, vividness);
      return;
    }

    // 2. Check First Dream Status
    final dreamService = DreamService();
    final isFirstDream = await dreamService.isFirstDream();
    if (isFirstDream) {
      if (mounted) Navigator.pop(context); // Close Mood Sheet
      await _processDream(mood, secondaryMoods, intensity, vividness, isFirstDream: true);
      return;
    }

    // 4. Check Short Dream (Skip Ad & Interpretation)
    // If dream is too short to interpret (< 50 chars), we don't show ad.
    // We just save it directly.
    if (_controller.text.length < 50) {
      if (mounted) Navigator.pop(context); // Close Mood Sheet
      await _processDream(mood, secondaryMoods, intensity, vividness);
      return;
    }

    // 5. Ad Flow for Standard Users

    // 4. Ad Flow for Standard Users
    if (!mounted) return;
    
    // [FIX] Strict Monetization:
    // If Ad is NOT ready, we must NOT give free interpretation.
    // Instead, we skip the ad flow but also SKIP the interpretation.
    if (!AdManager.instance.isAdLoaded) {
       debugPrint('Ad not ready. Skipping ad flow & interpretation.');
       if (mounted) Navigator.pop(context); // Close Mood Sheet
       
       // Process WITHOUT interpretation (Strict)
       await _processDream(mood, secondaryMoods, intensity, vividness, skipInterpretation: true);
       
       // Show specific feedback for this case if needed (Optional, but _processDream shows generic "Saved" snackbar)
       // We can rely on _processDream to show "Dream saved without interpretation".
       return;
    }

    // Only show dialog if Ad is actually ready to show
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AdConsentDialog(
        isAdLoaded: true, // Known true
        adLoadFailed: false,
      )
    );

    if (!mounted) return;

    if (result == 'pro') {
       if (mounted) Navigator.pop(context); // Close Mood Sheet
       
       // Show Paywall
       await showDialog(
         context: context, 
         builder: (context) => const ProUpgradeDialog()
       );
       
       if (!mounted) return;
       // Re-check PRO status after return
       final isNowPro = context.read<SubscriptionProvider>().isPro;
       
       // Proceed: If PRO, interpret. If NOT PRO, save without interpret (Skip).
       await _processDream(mood, secondaryMoods, intensity, vividness, skipInterpretation: !isNowPro);
       return;
    }

    if (result == 'watch') {
         // Close Mood Sheet FIRST
         if (mounted) Navigator.pop(context);

         // [FIX] Show simple black screen transition instead of full overlay
         if (mounted) {
           setState(() {
             _preparingAd = true;
             _isSaving = true; // Lock UI
           });
         }

         try {
           // Logic to show ad
           // Wrap in try-catch to ensure we NEVER leave the user stuck if Ad SDK crashes
           final shown = await AdManager.instance.showInterstitial(context);
           
           if (mounted) {
              setState(() => _preparingAd = false); // Hide transition screen
           }

           // If shown, process (Standard). 
           // If NOT shown (failed/timeout), we MUST skip interpretation to prevent leak.
           if (mounted) {
             await _processDream(mood, secondaryMoods, intensity, vividness, skipInterpretation: !shown);
           }
           
         } catch (e) {
           debugPrint("Ad Show Critical Error: $e");
           // FAILS PREDICATE: Proceed to save anyway, but SKIP INTERPRETATION
           if (mounted) {
             setState(() => _preparingAd = false);
             await _processDream(mood, secondaryMoods, intensity, vividness, skipInterpretation: true);
           }
         }
    } else if (result == 'retry') {
        // Retry logic - wait a bit then re-check
        Future.delayed(const Duration(milliseconds: 200), () { 
           if (mounted) _checkAdAndProcess(mood, secondaryMoods, intensity, vividness);
        });
    } else if (result == 'skip') {
        if (mounted) Navigator.pop(context); // Close Mood Sheet
        // [FIX] Skip Interpretation if user explicitly skips ad
        if (mounted) await _processDream(mood, secondaryMoods, intensity, vividness, skipInterpretation: true);
    }
    // If result is null (back button), do nothing. User is at Mood Sheet.
  }

  Future<void> _showOfflineDialog(String mood, List<String> secondaryMoods, int intensity, int vividness) async {
    final t = AppLocalizations.of(context)!;
    
    final shouldSave = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.bgMid,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.offlineSaveTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          t.offlineSaveContent,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Return false (Cancel)
            child: Text(t.offlineSaveCancel, style: const TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Return true (Confirm)
            child: Text(t.offlineSaveConfirm, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (shouldSave == true) {
      if (mounted) Navigator.pop(context); // Close Mood Sheet
      
      // Proceed to save without interpretation
      if (mounted) {
        await _processDream(mood, secondaryMoods, intensity, vividness, skipInterpretation: true);
      }
    }
  }

  Future<void> _processDream(String mood, List<String> secondaryMoods, int intensity, int vividness, {bool isFirstDream = false, bool skipInterpretation = false}) async {
    setState(() {
      _isSaving = true;
      _showAnalysisOverlay = true; // Show overlay
    });
    final t = AppLocalizations.of(context)!;
    
    try {
      final openAIService = OpenAIService();
      final locale = Localizations.localeOf(context).languageCode;
      
      String interpretation;
      String? title;
      
      // Check for internet connection first
      bool isConnected = false;
      try {
        isConnected = await ConnectivityService.isConnected.timeout(const Duration(seconds: 3));
      } catch (e) {
        isConnected = false;
      }
      
      if (!isConnected) {
        interpretation = t.offlineInterpretation;
        title = null;
      } else if (_controller.text.length < 50) {
        // Skip AI for short dreams
        interpretation = t.dreamTooShort;
        title = null;
      } else if (skipInterpretation) {
        // [FIX] Explicit Skip Validation
        interpretation = t.interpretationSkipped;
        title = null;
      } else {
        final result = await openAIService.interpretDream(_controller.text, mood, locale);
        // Check for rate limit error first
        if (result['error'] == 'rate_limit') {
          final resetMinutes = int.tryParse(result['resetMinutes'] ?? '5') ?? 5;
          setState(() => _rateLimitMinutes = resetMinutes);
          interpretation = t.rateLimitWait(resetMinutes);
          title = null;
        } else if (result.containsKey('error') || result['interpretation'] == null) {
          // Log the actual error for debugging
          debugPrint('Interpret Error: ${result['error']}');
          if (result.containsKey('details')) debugPrint('Error Details: ${result['details']}');
          
          interpretation = t.offlineInterpretation;
          title = null;
        } else {
          interpretation = result['interpretation']!;
          title = result['title'];
        }
      }
      
      // Save Dream
      final now = DateTime.now();
      final astronomicalEvents = AstronomyService.getEvents(now);
      
      // Get current guide stage for tracking
      final prefs = await SharedPreferences.getInstance();
      final guideStage = prefs.getInt('guide_progress');
      
      final dreamEntry = DreamEntry(
        id: now.millisecondsSinceEpoch.toString(),
        text: _controller.text,
        date: now,
        mood: mood,
        secondaryMoods: secondaryMoods,
        moodIntensity: intensity,
        vividness: vividness,
        interpretation: interpretation,
        title: title,
        astronomicalEvents: astronomicalEvents,
        guideStage: guideStage,
      );
      
      final dreamService = DreamService();
      await dreamService.saveDream(dreamEntry);
      
      // Increment daily usage (Abuse check mainly)
      await dreamService.incrementDailyUsage();
      
      // [NEW] Increment Weekly Usage if interpretation was provided (and not Pro)
      // Only check if we successfully got interpretation (not skipped, not offline error, not short)
      final bool gotInterpretation = !skipInterpretation && 
                                     interpretation != t.offlineInterpretation && 
                                     interpretation != t.dreamTooShort;
                                     
      if (gotInterpretation && !context.read<SubscriptionProvider>().isPro) {
          await dreamService.incrementWeeklyUsage();
      }
      
      // Mark first dream as used if applicable
      if (isFirstDream) {
        await dreamService.setFirstDreamUsed();
      }
      
      print("MyDream: Dream Saved: ${dreamEntry.id}");

      // Success Haptic
      HapticFeedback.mediumImpact();

      if (mounted) {
         // [FIX] Show Feedback if Skipped
         if (skipInterpretation && isConnected && _controller.text.length >= 50) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "${t.dreamSavedNoInterpretation}\n${t.watchAdForInterpretation}",
                  textAlign: TextAlign.center,
                ),
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppTheme.bgMid,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              )
            );
         }

         // Navigate to Journal
         Navigator.pushReplacement(
           context, 
           FastSlidePageRoute(child: const JournalScreen())
         );
      }
    } catch (e) {
       print("MyDream error: $e");
       if (mounted) {
         final t = AppLocalizations.of(context)!;
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${t.error}: $e')));
       }
    } finally {
      if (mounted) setState(() {
        _isSaving = false;
        _showAnalysisOverlay = false; // Hide overlay
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isPro = context.watch<SubscriptionProvider>().isPro;

    return Stack(
      children: [
        NightSkyBackground(
          isPro: isPro,
          child: Scaffold(
            resizeToAvoidBottomInset: !_isModalOpen, // [NEW] Prevent keyboard jump during modal interactions
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Semantics(
                label: t.close,
                button: true,
                child: IconButton(
                  icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              centerTitle: true,
              title: Semantics(
                header: true,
                child: GradientText(
                  t.newDreamTitle,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFF3E8FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            body: GestureDetector(
              onTap: () => _focusNode.unfocus(),
              behavior: HitTestBehavior.opaque,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  // Subtitle
                  Text(
                    t.newDreamSubtitle, 
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textMuted, fontStyle: FontStyle.italic, fontSize: 14),
                  ),
                  
                  // [REMOVED] Weekly Limit Indicator - Unlimited free interpretations
                  // Keeping this commented for potential future A/B testing
                  // if (!isPro) ...[...weekly limit UI...],

                  const SizedBox(height: 16),
                  
                  // Main Input Area (Expanded to fill space)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F0F23).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                      ),
                      child: TextField(
                        controller: _controller,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        focusNode: _focusNode,
                        maxLines: null,
                        expands: true, // Fills the container
                        maxLength: 3000,
                        cursorColor: const Color(0xFFA78BFA),
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                        decoration: InputDecoration(
                            hintText: t.newDreamPlaceholderDetail,
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.45), 
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            counter: null, 
                            counterText: "", 
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Character Counter
                  ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (context, TextEditingValue value, child) {
                      final currentLength = value.text.length;
                      Color color;
                      if (currentLength < 50) {
                        color = Colors.white54; 
                      } else if (currentLength < 3000) {
                        color = Colors.greenAccent; 
                      } else {
                        color = Colors.redAccent;
                      }

                      return Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, fontStyle: FontStyle.italic),
                              children: [
                                TextSpan(text: t.newDreamMinCharHint),
                                const TextSpan(text: "  "), 
                                TextSpan(
                                  text: '($currentLength/3000)',
                                  style: TextStyle(
                                    color: color, 
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Save Button (Fixed at bottom, moves up with keyboard)
                  ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (context, TextEditingValue value, child) {
                      final buttonText = value.text.length < 50 
                              ? t.newDreamSaveShort 
                              : t.newDreamSave;
                              
                      return Container(
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Semantics(
                          button: true,
                          enabled: !_isSaving,
                          label: _isSaving ? t.newDreamLoadingText : buttonText,
                          child: CustomButton(
                            // [UX IMPROVEMENT] Dynamic Text based on length
                            text: buttonText, 
                            loadingText: t.newDreamLoadingText,
                            onPressed: _handleSave,
                            isLoading: _isSaving,
                            // Icon removed as per request
                            icon: null,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
        // Analysis overlay (shown during AI processing)
        if (_showAnalysisOverlay)
          const Positioned.fill(
            child: DreamAnalysisOverlay(),
          ),

        // [NEW] Simple transition screen while ad loads
        if (_preparingAd)
          Positioned.fill(
            child: Container(color: const Color(0xFF0F0F23)), // Theme background color
          ),
      ],
    );
  }
}

// _MoodModal Removed
