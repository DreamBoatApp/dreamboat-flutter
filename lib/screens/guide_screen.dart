import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dream_boat_mobile/theme/app_theme.dart';
import 'package:dream_boat_mobile/widgets/background_sky.dart';
import 'package:dream_boat_mobile/widgets/glass_card.dart';
import 'package:dream_boat_mobile/widgets/custom_button.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';
import 'package:dream_boat_mobile/widgets/pro_upgrade_dialog.dart';
import 'package:dream_boat_mobile/services/review_service.dart';
import 'package:dream_boat_mobile/widgets/breathing_overlay.dart';
import 'package:dream_boat_mobile/services/dream_service.dart';
import 'package:dream_boat_mobile/models/dream_entry.dart';
import 'package:dream_boat_mobile/screens/new_dream_screen.dart';
import 'package:dream_boat_mobile/screens/journal_screen.dart';
import 'package:dream_boat_mobile/utils/custom_page_route.dart';
import 'package:dream_boat_mobile/widgets/time_awareness_exercise.dart'; 
import 'package:dream_boat_mobile/widgets/stage_checklist.dart'; // [NEW]
import 'package:flutter/services.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int _currentSlide = 0;
  int _progress = 0; // 0 to 7
  int? _expandedIndex;
  int _intentRepeatCount = 0; // Intent repetition counter for MILD
  List<DreamEntry> _wbtbDreams = []; // Cached WBTB dreams
  bool _isLoadingWbtbDreams = true;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  
  // Stage 5 Checklist State
  // Map of Task Key -> Current Stars
  Map<String, int> _stage5Progress = {};
  
  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load intent exercise count
    // If completed (10), keep forever. Otherwise, reset daily.
    int intentCount = prefs.getInt('intent_exercise_count') ?? 0;
    if (intentCount < 10) {
      // Not completed - check if needs daily reset
      final lastIntentDate = prefs.getString('intent_exercise_date');
      final today = DateTime.now().toIso8601String().substring(0, 10);
      if (lastIntentDate != today) {
        intentCount = 0; // Reset for new day
      }
    }
    // If intentCount >= 10, keep it forever (completed state)
    
    setState(() {
      _progress = prefs.getInt('guide_progress') ?? 0;
      _intentRepeatCount = intentCount;
      
      // Load Stage 5 Checklist (Persisted as simple Ints)
      _stage5Progress = {
        'task1': prefs.getInt('stage5_task1') ?? 0,
        'task2': prefs.getInt('stage5_task2') ?? 0,
      };
    });
    
    _loadWbtbDreams();
  }

  Future<void> _updateStage5Progress(String taskKey, int stars) async {
    setState(() {
      _stage5Progress[taskKey] = stars;
    });
    
    final prefs = await SharedPreferences.getInstance();
    if (taskKey == 'task1') {
       await prefs.setInt('stage5_task1', stars);
    } else if (taskKey == 'task2') {
       await prefs.setInt('stage5_task2', stars);
    }
  }

  Future<void> _loadWbtbDreams() async {
    try {
      final service = DreamService();
      final allDreams = await service.getDreams();
      
      // Filter dreams recorded during STAGE 1 (WBTB)
      // guideStage field is new, so old dreams will be null
      final wbtbDreams = allDreams.where((d) => d.guideStage == 1).toList();
      
      if (mounted) {
        setState(() {
          _wbtbDreams = wbtbDreams;
          _isLoadingWbtbDreams = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading WBTB dreams: $e');
      if (mounted) {
        setState(() {
          _isLoadingWbtbDreams = false;
        });
      }
    }
  }

  List<StageData> get _stages {
    final t = AppLocalizations.of(context)!;
    return [
      StageData(
        title: t.guideStage1Title, subtitle: t.guideStage1Subtitle, content: t.guideStage1Content, importance: t.guideStage1Importance, steps: t.guideStage1Steps.split('\n'), criteria: t.guideStage1Criteria, brainNote: t.guideStage1BrainNote
      ),
      StageData(
        title: t.guideStage2Title, subtitle: t.guideStage2Subtitle, content: t.guideStage2Content, importance: t.guideStage2Importance, steps: t.guideStage2Steps.split('\n'), criteria: t.guideStage2Criteria, brainNote: t.guideStage2BrainNote
      ),
      StageData(
        title: t.guideStage3Title, subtitle: t.guideStage3Subtitle, content: t.guideStage3Content, importance: t.guideStage3Importance, steps: t.guideStage3Steps.split('\n'), criteria: t.guideStage3Criteria, brainNote: t.guideStage3BrainNote
      ),
      StageData(
        title: t.guideStage4Title, subtitle: t.guideStage4Subtitle, content: t.guideStage4Content, importance: t.guideStage4Importance, steps: t.guideStage4Steps.split('\n'), criteria: t.guideStage4Criteria, brainNote: t.guideStage4BrainNote
      ),
      StageData(
        title: t.guideStage5Title, subtitle: t.guideStage5Subtitle, content: t.guideStage5Content, importance: t.guideStage5Importance, steps: t.guideStage5Steps.split('\n'), criteria: t.guideStage5Criteria, brainNote: t.guideStage5BrainNote
      ),
      StageData(
        title: t.guideStage6Title, subtitle: t.guideStage6Subtitle, content: t.guideStage6Content, importance: t.guideStage6Importance, steps: t.guideStage6Steps.split('\n'), criteria: t.guideStage6Criteria, brainNote: t.guideStage6BrainNote
      ),
      StageData(
        title: t.guideStage7Title, subtitle: t.guideStage7Subtitle, content: t.guideStage7Content, importance: t.guideStage7Importance, steps: t.guideStage7Steps.split('\n'), criteria: t.guideStage7Criteria, brainNote: t.guideStage7BrainNote
      ),
    ];
  }

  bool get _canAdvance {
    // Only Stage 5 (Optimization) - index 4 has criteria
    if (_progress == 4) {
       final stars1 = _stage5Progress['task1'] ?? 0;
       final stars2 = _stage5Progress['task2'] ?? 0;
       return stars1 >= 7 && stars2 >= 3;
    }

    // For all other stages, allow advancing immediately
    return true; 
  }

  Future<void> _advanceProgress() async {
     final t = AppLocalizations.of(context)!;

     if (!_canAdvance) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(t.guideCriteriaNotMet),
           backgroundColor: Colors.redAccent,
         )
       );
       return; 
     }

     final prefs = await SharedPreferences.getInstance();
     if (_progress < _stages.length - 1) {
       final newVal = _progress + 1;
       await prefs.setInt('guide_progress', newVal);
       setState(() {
         _progress = newVal;
         _expandedIndex = newVal; // Auto expand next
       });
       if (_scrollController.hasClients) {
          _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
       }
       
       // Trigger review flow on level up
       if (context.mounted) {
         ReviewService.triggerReviewFlow(context);
       }
     } else {
       // Completed all
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.guideCompleted)));
     }
  }

  void _confirmComplete() {
    final t = AppLocalizations.of(context)!;
    showGeneralDialog(
      context: context, 
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.8),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              // Gradient Border
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFBBF24).withOpacity(0.6), // Gold
                  const Color(0xFF9333EA).withOpacity(0.4), // Purple
                ]
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFBBF24).withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5
                )
              ]
            ),
            child: Container(
               margin: const EdgeInsets.all(1.5), // For border width
               clipBehavior: Clip.hardEdge,
               decoration: BoxDecoration(
                 color: const Color(0xFF0F0B1E).withOpacity(0.95), // Deep Dark Background
                 borderRadius: BorderRadius.circular(31),
               ),
               child: Stack(
                 children: [
                   // Background Particles/Glow
                   Positioned(
                     top: -50, right: -50,
                     child: Container(
                       width: 150, height: 150,
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         color: const Color(0xFFFBBF24).withOpacity(0.1),
                         boxShadow: [BoxShadow(color: const Color(0xFFFBBF24).withOpacity(0.2), blurRadius: 60, spreadRadius: 20)]
                       ),
                     ),
                   ),
                   
                   Padding(
                     padding: const EdgeInsets.fromLTRB(24, 32, 24, 24), // Reduced padding
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         // Title
                         Text(
                           t.guideDialogTitle,
                           style: const TextStyle(
                             color: Colors.white, 
                             fontSize: 18, 
                             fontWeight: FontWeight.bold,
                             fontFamily: 'Inter', // Ensure premium font
                             decoration: TextDecoration.none
                           ),
                           textAlign: TextAlign.center,
                         ),
                         const SizedBox(height: 16),
                         
                         // Content
                         Text(
                           t.guideDialogContent,
                           style: TextStyle(
                             color: Colors.white.withOpacity(0.7), 
                             fontSize: 14, 
                             height: 1.6,
                             fontFamily: 'Inter',
                             decoration: TextDecoration.none
                           ),
                           textAlign: TextAlign.center,
                         ),
                         const SizedBox(height: 28), // Slightly reduced from 32

                         // Buttons
                         Row(
                           children: [
                             // Cancel
                             Expanded(
                               child: TextButton(
                                 onPressed: () => Navigator.pop(ctx),
                                 style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                 ),
                                 child: Text(
                                   t.guideDialogCancel, 
                                   style: TextStyle(
                                     color: Colors.white.withOpacity(0.6),
                                     fontSize: 15,
                                     fontWeight: FontWeight.w500
                                   )
                                 ),
                               ),
                             ),
                             const SizedBox(width: 16),
                             
                             // Confirm (Gradient)
                             Expanded(
                               child: Container(
                                 height: 54,
                                 decoration: BoxDecoration(
                                   gradient: const LinearGradient(
                                     colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
                                   ),
                                   borderRadius: BorderRadius.circular(16),
                                   boxShadow: [
                                     BoxShadow(
                                       color: const Color(0xFFFBBF24).withOpacity(0.3),
                                       blurRadius: 12,
                                       offset: const Offset(0, 4)
                                     )
                                   ]
                                 ),
                                 child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      _advanceProgress();
                                    },
                                    style: ElevatedButton.styleFrom(
                                       backgroundColor: Colors.transparent,
                                       shadowColor: Colors.transparent,
                                       padding: EdgeInsets.zero,
                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          t.guideDialogConfirm, // Usually "Devam Et"
                                          style: const TextStyle(
                                            fontSize: 15, 
                                            fontWeight: FontWeight.bold, 
                                            color: Colors.black
                                          )
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(LucideIcons.arrowRight, size: 18, color: Colors.black)
                                      ],
                                    ),
                                 ),
                               ),
                             )
                           ],
                         )
                       ],
                     ),
                   ),
                 ],
               )
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  void _showUpgradeDialog() {
    showDialog(context: context, builder: (ctx) => const ProUpgradeDialog());
  }

  @override
  Widget build(BuildContext context) {
    // Watch PRO status
    final isPro = context.watch<SubscriptionProvider>().isPro;

    return NightSkyBackground(
      isPro: isPro,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.guideAppBarTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFBBF24))),
        ),
        // If PRO -> Show Stages List directly
        // If Standard -> Show Intro Carousel (with lock at end)
        body: isPro ? _buildStagesList() : _buildIntroCarousel(),
      ),
    );
  }

  // --- INTRO CAROUSEL ---

  Widget _buildIntroCarousel() {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentSlide = idx),
            children: [
              _buildSlide1(),
              _buildSlide2(),
              _buildSlide3(),
              _buildSlide4(),
            ],
          ),
        ),
        // Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 10, height: 10,
            decoration: BoxDecoration(
              color: _currentSlide == index ? const Color(0xFFFBBF24) : Colors.white24,
              shape: BoxShape.circle,
              boxShadow: _currentSlide == index 
                  ? [BoxShadow(color: const Color(0xFFFBBF24).withOpacity(0.5), blurRadius: 4, spreadRadius: 1)] 
                  : null,
            ),
          )),
        ),
        const SizedBox(height: 20),
        // Nav Buttons
        Padding(
          padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _currentSlide > 0 ? () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut) : null,
                icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
                disabledColor: Colors.white10,
              ),
              const SizedBox(width: 30),
              IconButton(
                onPressed: _currentSlide < 3 ? () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut) : null,
                icon: const Icon(LucideIcons.chevronRight, color: Colors.white),
                disabledColor: Colors.white10,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSlideContainer({required String title, required Widget content, Widget? footer, String? bgImage}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: Container(
          width: double.infinity,
          height: 620, // Increased height to prevent scrolling on dense cards
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // Darker default background (Deepest Blue/Black) to match the visual weight of image cards
            color: const Color(0xFF02020A).withOpacity(0.95), 
            image: bgImage != null ? DecorationImage(
              image: AssetImage(bgImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken)
            ) : null,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFFBBF24).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(color: const Color(0xFFFBBF24).withOpacity(0.1), blurRadius: 20, spreadRadius: 0)
            ]
          ),
          child: Column( 
            children: [
              Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      content,
                      if (footer != null) ...[
                        const SizedBox(height: 16),
                        footer
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlide1() {
    final t = AppLocalizations.of(context)!;
    return _buildSlideContainer(
      title: t.guideSlide1Title,
      bgImage: 'assets/images/guide_egypt_bg.png',
      content: Column(
        children: [
          Text(
            t.guideSlide1Subtitle,
            style: TextStyle(color: Color(0xFFFBBF24), fontSize: 16, fontStyle: FontStyle.italic), textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            t.guideSlide1Content1,
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5), textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            t.guideSlide1Content2,
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5), textAlign: TextAlign.center,
          ),
        ],
      )
    );
  }

  Widget _buildSlide2() {
    final t = AppLocalizations.of(context)!;
    return _buildSlideContainer(
      title: t.guideSlide2Title,
      bgImage: 'assets/images/guide_tibet_bg.png',
      content: Column(
        children: [
          Text(
            t.guideSlide2Subtitle,
            style: TextStyle(color: Color(0xFFFBBF24), fontSize: 16, fontStyle: FontStyle.italic), textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            t.guideSlide2Content1,
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5), textAlign: TextAlign.center,
          ),
           const SizedBox(height: 16),
           Text(
            t.guideSlide2Content2,
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5), textAlign: TextAlign.center,
          ),
        ],
      )
    );
  }

  Widget _buildSlide3() {
    final t = AppLocalizations.of(context)!;
    return _buildSlideContainer(
      title: t.guideSlide3Title,
      bgImage: 'assets/images/guide_dreamcatcher_bg.png',
      content: Column(
        children: [
          Text(
            t.guideSlide3Subtitle,
            style: TextStyle(color: Color(0xFFFBBF24), fontSize: 16, fontStyle: FontStyle.italic), textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            t.guideSlide3Content1,
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5), textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            t.guideSlide3Content2,
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5), textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSlide4() {
    final t = AppLocalizations.of(context)!;
    return _buildSlideContainer(
      title: t.guideSlide4Title,
      // bgImage removed to use default darker color
      content: Column(
        children: [
          Text(
            t.guideSlide4Content,
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5), textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFBBF24).withOpacity(0.2))
            ),
            child: Column(
              children: [
                Text(t.guideSlide4GainsTitle, style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),
                _buildBullet(t.guideSlide4Gain1),
                _buildBullet(t.guideSlide4Gain2),
                _buildBullet(t.guideSlide4Gain3),
                _buildBullet(t.guideSlide4Gain4),
              ],
            ),
          ),
        ],
      ),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
             Text(
                t.guideSlide4ProRequired,
                style: const TextStyle(color: Colors.white70, fontSize: 13, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
             ),
             const SizedBox(height: 12),
             SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBBF24), // Orange/Gold
                    foregroundColor: Colors.black,
                    minimumSize: const Size(48, 48),
                    tapTargetSize: MaterialTapTargetSize.padded,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _showUpgradeDialog,
                  child: Text(
                    t.guideSlide4UnlockButton,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), 
                    textAlign: TextAlign.center,
                  ),
                ),
             ),
        ],
      )
    );
  }

  // --- STAGES LIST ---

  Widget _buildStagesList() {
    final stages = _stages;
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: stages.length,
      itemBuilder: (ctx, index) {
        final t = AppLocalizations.of(context)!;
        final stage = stages[index];
        final isUnlocked = index <= _progress;
        final isCompleted = index < _progress;
        final isCurrent = index == _progress;
        final isExpanded = _expandedIndex == index || isCurrent;
        
        // Colors
        final mainColor = isCompleted ? const Color(0xFF4ADE80) : const Color(0xFFFBBF24); // Green or Amber
        final bgColor = isCompleted ? const Color(0xFF4ADE80).withOpacity(0.05) : const Color(0xFFFBBF24).withOpacity(0.05);

        if (!isUnlocked) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
               color: Colors.white.withOpacity(0.02),
               border: Border.all(color: Colors.white.withOpacity(0.05)),
               borderRadius: BorderRadius.circular(16)
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Expanded(child: Text(stage.title, style: const TextStyle(color: Colors.white38, fontSize: 15), overflow: TextOverflow.ellipsis)),
                 const SizedBox(width: 8),
                 const Icon(LucideIcons.lock, color: Colors.white38, size: 18)
               ],
             ),
          );
        }

       return Material(
         type: MaterialType.transparency,
         child: InkWell(
           borderRadius: BorderRadius.circular(16),
           splashColor: Colors.white.withOpacity(0.1),
           highlightColor: Colors.white.withOpacity(0.05),
           onTap: () {
             // Only allow expanding if it's the current stage or already completed
             if (isCurrent || isCompleted) {
               setState(() => _expandedIndex = _expandedIndex == index ? null : index);
             }
           },
           child: AnimatedContainer(
           duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: mainColor.withOpacity(isExpanded || isCompleted ? 0.5 : 0.3)),
              borderRadius: BorderRadius.circular(16)
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                   child: Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(stage.title, style: TextStyle(color: mainColor, fontSize: 17, fontWeight: FontWeight.bold)),
                             const SizedBox(height: 4),
                             Text(stage.subtitle, style: TextStyle(color: mainColor.withOpacity(0.8), fontSize: 13, fontStyle: FontStyle.italic)),
                           ],
                         ),
                       ),
                       if (isCompleted) Icon(LucideIcons.checkCircle, color: mainColor, size: 24),
                     ],
                   ),
                ),
                
                // Content
                if (isExpanded) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(color: Colors.white10, height: 20),
                        _buildSectionTitle(t.guideContent),
                        Text(stage.content, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.6)),
                        const SizedBox(height: 20),
                        
                        _buildSectionTitle(t.guideImportance),
                        Text(stage.importance, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.6)),
                        const SizedBox(height: 20),

                        // Steps
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.guideSteps, style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 12),
                              ...stage.steps.map((s) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text("• $s", style: const TextStyle(color: Colors.white70, fontSize: 14)),
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Criteria
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(left: BorderSide(color: mainColor, width: 3)),
                            color: mainColor.withOpacity(0.1)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.guideCriteria, style: TextStyle(color: mainColor, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(stage.criteria, style: const TextStyle(color: Colors.white, fontSize: 13)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Brain Note (Hidden in Turkish)
                        if (Localizations.localeOf(context).languageCode != 'tr')
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white24, style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white.withOpacity(0.02)
                            ),
                            child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(t.guideBrainNoteTitle, style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
                                 const SizedBox(height: 4),
                                 Text(stage.brainNote, style: const TextStyle(color: Colors.white38, fontSize: 13, fontStyle: FontStyle.italic)),
                               ]
                            ),
                          ),
                        
                        // Intent Repetition Exercise (MILD only - index 0)
                        if (index == 0) _buildIntentRepetitionExercise(),
                        
                        // Dream Link Card (WBTB only - index 1)
                        if (index == 1) _buildWbtbDreamLinkCard(),

                        // Breathing Exercise (WILD only - index 2)
                        if (index == 2) _buildWildBreathingExercise(),

                        // Time Awareness Exercise (Stage 4 - index 3)
                        if (index == 3) const TimeAwarenessExercise(),
                        
                        // Stage 5 Checklist (Index 4)
                        if (index == 4) 
                          StageChecklist(
                            tasks: {
                              'task1': 7, // Use fixed keys for internal logic
                              'task2': 3
                            },
                            progress: {
                              'task1': _stage5Progress['task1'] ?? 0,
                              'task2': _stage5Progress['task2'] ?? 0,
                            }, 
                            taskTitles: { // Pass localized titles for display
                              'task1': t.stage5Task1,
                              'task2': t.stage5Task2,
                            },
                            onProgressChanged: (taskKey, stars) {
                               _updateStage5Progress(taskKey, stars);
                            },
                          ),
                        
                        const SizedBox(height: 24),

                        if (!isCompleted && index < stages.length - 1)
                          // Advance Button
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                // Hint Text for Stage 5
                                if (index == 4) 
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 32, left: 24, right: 24),
                                    child: Text(
                                      t.stage5Hint,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  ),
                                  
                                ElevatedButton(
                                  onPressed: _canAdvance ? () {
                                    if (index == _stages.length - 1) {
                                      // Mastery
                                    } else {
                                      _confirmComplete();
                                    }
                                  } : null, // Disable if not met
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _canAdvance ? const Color(0xFFFBBF24) : Colors.white10,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: _canAdvance ? 4 : 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        index == _stages.length - 1 ? t.guideCompleted : t.guideNextStep,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, 
                                          fontSize: 16,
                                          color: _canAdvance ? Colors.black : Colors.white38
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        LucideIcons.arrowRight, 
                                        size: 18,
                                        color: _canAdvance ? Colors.black : Colors.white38,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (index == stages.length - 1)
                           Container(
                             width: double.infinity,
                             padding: const EdgeInsets.all(16),
                             decoration: BoxDecoration(
                               color: Colors.white.withOpacity(0.1),
                               borderRadius: BorderRadius.circular(12),
                               border: Border.all(color: const Color(0xFFFBBF24).withOpacity(0.3))
                             ),
                             child: Text(
                               "${t.guideCompletionTitle}\n\n${t.guideCompletionContent}",
                               textAlign: TextAlign.center,
                               style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold, height: 1.5),
                             ),
                           )
                      ],
                    ),
                  )
                ]
              ],
            ),
          ),
         ),
        );
      },
    );
  }

  // Helpers
  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.star, color: Color(0xFFFBBF24), size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14))),
        ],
      ),
    );
  }
  
  Widget _buildBulletSimple(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, color: Colors.white70, size: 6),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
    );
  }

  // Intent Repetition Exercise for MILD
  Future<void> _incrementIntentCount() async {
    if (_intentRepeatCount >= 10) return;
    
    // Haptic feedback
    HapticFeedback.mediumImpact();
    
    final newCount = _intentRepeatCount + 1;
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    
    await prefs.setInt('intent_exercise_count', newCount);
    await prefs.setString('intent_exercise_date', today);
    
    setState(() {
      _intentRepeatCount = newCount;
    });
    
    // Extra haptic on completion
    if (newCount == 10) {
      HapticFeedback.heavyImpact();
    }
  }

  Widget _buildIntentRepetitionExercise() {
    final t = AppLocalizations.of(context)!;
    // Show as complete if counter reached 10 OR if stage is already completed (progress > 0)
    final isComplete = _intentRepeatCount >= 10 || _progress > 0;
    final progress = _intentRepeatCount / 10;
    
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isComplete 
            ? [const Color(0xFF4ADE80).withOpacity(0.15), const Color(0xFF22C55E).withOpacity(0.1)]
            : [const Color(0xFFFBBF24).withOpacity(0.1), const Color(0xFFD97706).withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isComplete ? const Color(0xFF4ADE80).withOpacity(0.4) : const Color(0xFFFBBF24).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Title - centered without icon
          Text(
            t.guideIntentExerciseTitle,
            style: TextStyle(
              color: isComplete ? const Color(0xFF4ADE80) : const Color(0xFFFBBF24),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Intent Phrase
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Text(
              '"${t.guideIntentPhrase}"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Button or Completion Message
          if (isComplete)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4ADE80).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                t.guideIntentComplete,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF4ADE80),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _incrementIntentCount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFBBF24),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  t.guideIntentRepeatButton,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          const SizedBox(height: 12),
          
          // Progress
          Column(
            children: [
              Text(
                t.guideIntentProgress(_intentRepeatCount),
                style: TextStyle(
                  color: isComplete ? const Color(0xFF4ADE80) : Colors.white70,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              // Animated Progress Bar
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Container(
                    height: 6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isComplete 
                              ? [const Color(0xFF4ADE80), const Color(0xFF22C55E)]
                              : [const Color(0xFFFBBF24), const Color(0xFFD97706)],
                          ),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: (isComplete ? const Color(0xFF4ADE80) : const Color(0xFFFBBF24)).withOpacity(0.4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // WILD Breathing Exercise for Stage 3
  void _showBreathingOverlay() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: const BreathingOverlay(),
          );
        },
      ),
    );
  }

  Widget _buildWildBreathingExercise() {
    final t = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF60A5FA).withOpacity(0.2),
              const Color(0xFF818CF8).withOpacity(0.15),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF60A5FA).withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: const Color(0xFF818CF8).withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _showBreathingOverlay,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Center(
                child: Text(
                  t.wildBreathStart,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWbtbDreamLinkCard() {
    final t = AppLocalizations.of(context)!;
    final hasDreams = _wbtbDreams.isNotEmpty;
    
    // While loading, show nothing or specific loader? 
    // Just showing nothing is safer to avoid flicker if fast
    if (_isLoadingWbtbDreams) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row (Icon removed)
          Row(
            children: [
              Expanded(
                child: Text(
                  hasDreams ? t.wbtbDreamsTitle : t.wbtbNoDreamsTitle,
                  style: const TextStyle(
                    color: Color(0xFFFBBF24), // Amber
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          Text(
            hasDreams ? t.wbtbDreamsDesc : t.wbtbNoDreamsDesc,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action Button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                if (hasDreams) {
                   Navigator.push(
                    context, 
                    FastSlidePageRoute(
                      child: JournalScreen(
                        filter: (d) => d.guideStage == 1,
                        filterTitle: t.wbtbDreamsTitle,
                      )
                    )
                  );
                } else {
                  // Navigate to New Dream Screen
                  Navigator.push(
                    context, 
                    FastSlidePageRoute(child: const NewDreamScreen())
                  ).then((_) {
                    // Refresh dreams after coming back
                    _loadWbtbDreams();
                  });
                }
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.white.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    hasDreams ? t.wbtbDreamsButton : t.wbtbAddFirstDream,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(LucideIcons.arrowRight, size: 14, color: Colors.white70),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class StageData {
  final String title;
  final String subtitle;
  final String content;
  final String importance;
  final List<String> steps;
  final String criteria;
  final String brainNote;
  
  const StageData({
    required this.title, required this.subtitle, required this.content, 
    required this.importance, required this.steps, required this.criteria, required this.brainNote
  });
}
