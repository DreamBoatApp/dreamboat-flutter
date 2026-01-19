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
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
    });
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

  Future<void> _advanceProgress() async {
     final t = AppLocalizations.of(context)!;
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
    showDialog(
      context: context, 
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1B35).withOpacity(0.95), // Premium Dark
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFFBBF24).withOpacity(0.3)), // Amber Border
            boxShadow: [
              BoxShadow(
                 color: const Color(0xFFFBBF24).withOpacity(0.1),
                 blurRadius: 20, 
                 spreadRadius: 5
              )
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

               Text(
                 t.guideDialogTitle,
                 style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                 textAlign: TextAlign.center,
               ),
               const SizedBox(height: 12),
               Text(
                 t.guideDialogContent,
                 style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14, height: 1.5),
                 textAlign: TextAlign.center,
               ),
               const SizedBox(height: 24),
               Row(
                 children: [
                   Expanded(
                     child: TextButton(
                       onPressed: () => Navigator.pop(ctx),
                       style: TextButton.styleFrom(
                          minimumSize: const Size(48, 48),
                          tapTargetSize: MaterialTapTargetSize.padded,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                       ),
                       child: Text(t.guideDialogCancel, style: const TextStyle(color: Colors.white70)),
                     ),
                   ),
                   const SizedBox(width: 12),
                   Expanded(
                     child: Container(
                       decoration: BoxDecoration(
                         gradient: const LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFD97706)]), // Amber Gradient
                         borderRadius: BorderRadius.circular(12),
                         boxShadow: [
                           BoxShadow(color: const Color(0xFFFBBF24).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
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
                             minimumSize: const Size(48, 48),
                             tapTargetSize: MaterialTapTargetSize.padded,
                             padding: const EdgeInsets.symmetric(vertical: 12),
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                          ),
                          child: Text(t.guideDialogConfirm, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                       ),
                     ),
                   )
                 ],
               )
            ],
          ),
        ),
      )
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
             if (isCompleted) {
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
                        
                        const SizedBox(height: 24),

                        if (!isCompleted && index < stages.length - 1)
                          CustomButton(
                            text: t.guideNextStep,
                            onPressed: _confirmComplete,
                            gradient: const LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFD97706)]),
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
    final isComplete = _intentRepeatCount >= 10;
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
