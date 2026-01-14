import 'dart:ui'; // Needed for ImageFilter
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dream_boat_mobile/theme/app_theme.dart';
import 'package:dream_boat_mobile/widgets/background_sky.dart';
import 'package:dream_boat_mobile/services/connectivity_service.dart'; 
import 'package:dream_boat_mobile/widgets/glass_card.dart';
import 'package:dream_boat_mobile/widgets/custom_button.dart';
import 'package:dream_boat_mobile/widgets/ad_consent_dialog.dart'; // [NEW]

import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/services/openai_service.dart';
import 'package:dream_boat_mobile/services/dream_service.dart';
import 'package:dream_boat_mobile/services/ad_manager.dart';
import 'package:dream_boat_mobile/models/dream_entry.dart';
import 'package:dream_boat_mobile/screens/journal_screen.dart';
import 'package:dream_boat_mobile/widgets/gradient_text.dart';
import 'package:dream_boat_mobile/utils/custom_page_route.dart'; 

import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';

class NewDreamScreen extends StatefulWidget {
  const NewDreamScreen({super.key});

  @override
  State<NewDreamScreen> createState() => _NewDreamScreenState();
}

class _NewDreamScreenState extends State<NewDreamScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() {
    FocusScope.of(context).unfocus(); // Close keyboard before checking/showing modals
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    // Validation: Allow short dreams, but they won't be interpreted.
    // Proceed to mood selection regardless of length (as long as not empty)
    _showMoodModal();
  }

  void _showMoodModal() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => _MoodModal(
        onSelect: (mood) {
          Navigator.pop(context); // Close modal
          _checkAdAndProcess(mood);
        }
      ),
    );
  }
  
  Future<void> _checkAdAndProcess(String mood) async {
    // 1. Check PRO Status
    final isPro = context.read<SubscriptionProvider>().isPro;
    if (isPro) {
      // PRO: Directly process without ads
      await _processDream(mood);
      return;
    }

    // 2. Check First Dream Status
    final dreamService = DreamService();
    final isFirstDream = await dreamService.isFirstDream();
    if (isFirstDream) {
      // First Dream: Free, no ad
      await _processDream(mood, isFirstDream: true);
      return;
    }

    // 3. Ad Flow for Standard Users
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false, // User must choose
      builder: (context) => AdConsentDialog(
        isAdLoaded: AdManager.instance.isAdLoaded,
        onWatchAd: () async {
            // 0. Check if user became PRO inside the dialog flow
            if (context.read<SubscriptionProvider>().isPro) {
               if (mounted) _processDream(mood);
               return;
            }

            // Logic to show ad
            final shown = await AdManager.instance.showInterstitial(context);
            if (shown) {
                // Ad shown. Proceed to process dream.
                if (mounted) _processDream(mood);
            } else {
              // Failed to show? 
              if (mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Failed to load ad. Please try again or go PRO.'))
                 );
                 // Re-open dialog to let them try again or go PRO
                 _checkAdAndProcess(mood); 
              }
            }
        },
        onRetry: () {
           // Retry checking logic
           Navigator.pop(context); 
           // Reload logic is simpler: AdManager auto-reloads.
           // Just re-triggering the check will re-open dialog with updated state
           Future.delayed(const Duration(seconds: 1), () {
              if (mounted) _checkAdAndProcess(mood);
           });
        },
      )
    );
  }

  Future<void> _processDream(String mood, {bool isFirstDream = false}) async {
    setState(() => _isSaving = true);
    final t = AppLocalizations.of(context)!;
    
    try {
      final openAIService = OpenAIService();
      final locale = Localizations.localeOf(context).languageCode;
      
      String interpretation;
      String? title;
      
      // Check for internet connection first
      final isConnected = await ConnectivityService.isConnected;
      
      if (!isConnected) {
        interpretation = t.offlineInterpretation;
        title = null;
      } else if (_controller.text.length < 50) {
        // Skip AI for short dreams
        interpretation = t.dreamTooShort;
        title = null;
      } else {
        final result = await openAIService.interpretDream(_controller.text, mood, locale);
        interpretation = result['interpretation'] ?? t.dreamTooShort;
        title = result['title'];
      }
      
      // Save Dream
      final dreamEntry = DreamEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _controller.text,
        date: DateTime.now(),
        mood: mood,
        interpretation: interpretation,
        title: title,
      );
      
      final dreamService = DreamService();
      await dreamService.saveDream(dreamEntry);
      
      // Increment daily usage (Abuse check mainly)
      await dreamService.incrementDailyUsage();
      
      // Mark first dream as used if applicable
      if (isFirstDream) {
        await dreamService.setFirstDreamUsed();
      }
      
      print("MyDream: Dream Saved: ${dreamEntry.id}");

      if (mounted) {
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
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isPro = context.watch<SubscriptionProvider>().isPro;

    return NightSkyBackground(
      isPro: isPro,
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Ensure we resize when keyboard opens
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: GradientText(
            t.newDreamTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF3E8FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                  Container(
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 10), // Add padding only if keyboard closed
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
                    child: CustomButton(
                      text: t.newDreamSave, 
                      loadingText: t.newDreamLoadingText,
                      onPressed: _handleSave,
                      isLoading: _isSaving,
                      icon: null,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
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

class _MoodModal extends StatelessWidget {
  final Function(String) onSelect;

  const _MoodModal({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    // Specific order and colors from screenshot
    final moods = [
      {'key': 'love', 'label': t.moodLove, 'icon': LucideIcons.heart, 'color': const Color(0xFFEC4899)}, // Pink
      {'key': 'happy', 'label': t.moodHappy, 'icon': LucideIcons.smile, 'color': const Color(0xFFFBBF24)}, // Yellow
      {'key': 'sad', 'label': t.moodSad, 'icon': LucideIcons.cloudRain, 'color': const Color(0xFF60A5FA)}, // Blue
      {'key': 'scared', 'label': t.moodScared, 'icon': LucideIcons.ghost, 'color': const Color(0xFF8B5CF6)}, // Purple
      {'key': 'anger', 'label': t.moodAnger, 'icon': LucideIcons.flame, 'color': const Color(0xFFEF4444)}, // Red
      {'key': 'neutral', 'label': t.moodNeutral, 'icon': LucideIcons.meh, 'color': const Color(0xFF9CA3AF)}, // Grey
    ];

    return Dialog(
       backgroundColor: Colors.transparent,
       elevation: 0,
       child: ClipRRect(
         borderRadius: BorderRadius.circular(28),
         child: BackdropFilter(
           filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Strong Glass Blur
           child: Container(
             width: double.infinity,
             padding: const EdgeInsets.all(24),
             decoration: BoxDecoration(
               color: const Color(0xFF0F0F23).withOpacity(0.6), // Consistent dark tint, clearer
               borderRadius: BorderRadius.circular(28),
               border: Border.all(color: Colors.white.withOpacity(0.15)), // Subtle border
               boxShadow: [
                 BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, spreadRadius: 5),
               ]
             ),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             GradientText(
               t.newDreamModalTitle, 
               textAlign: TextAlign.center,
               style: const TextStyle(
                 fontSize: 20, 
                 fontWeight: FontWeight.bold,
                 height: 1.3
               ),
               gradient: const LinearGradient(
                 colors: [Colors.white, Color(0xFFF3E8FF)],
                 begin: Alignment.centerLeft,
                 end: Alignment.centerRight,
               ),
             ),
             const SizedBox(height: 24),
             GridView.builder(
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 3, 
                 mainAxisSpacing: 12, 
                 crossAxisSpacing: 12,
                 childAspectRatio: 1.0, // Square items
               ),
               itemCount: moods.length,
               itemBuilder: (context, index) {
                 final m = moods[index];
                 return Material(
                   type: MaterialType.transparency,
                   child: InkWell(
                     borderRadius: BorderRadius.circular(16),
                     splashColor: Colors.white.withOpacity(0.1),
                     highlightColor: Colors.white.withOpacity(0.05),
                     onTap: () => onSelect(m['key'] as String),
                     child: Container(
                       decoration: BoxDecoration(
                         border: Border.all(color: (m['color'] as Color).withOpacity(0.5), width: 1.5),
                         borderRadius: BorderRadius.circular(16),
                         color: Colors.transparent,
                       ),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(m['icon'] as IconData, color: m['color'] as Color, size: 28),
                           const SizedBox(height: 8),
                           Text(m['label'] as String, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                         ],
                       ),
                     ),
                   ),
                 );
               },
             ),
             const SizedBox(height: 24),
             TextButton(
               onPressed: () => Navigator.pop(context),
               child: Text(t.close, style: const TextStyle(color: Colors.white54, fontSize: 16)),
             )
           ],
         ),
       ),
         ),
       ),
    );
  }
}
