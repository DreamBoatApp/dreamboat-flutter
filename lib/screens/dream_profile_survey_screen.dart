import 'package:flutter/material.dart';
import 'package:dream_boat_mobile/widgets/background_sky.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_boat_mobile/screens/home_screen.dart';
import 'package:dream_boat_mobile/widgets/custom_button.dart';
import 'package:dream_boat_mobile/widgets/mystic_orb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class DreamProfileSurveyScreen extends StatefulWidget {
  const DreamProfileSurveyScreen({super.key});

  @override
  State<DreamProfileSurveyScreen> createState() => _DreamProfileSurveyScreenState();
}

class _DreamProfileSurveyScreenState extends State<DreamProfileSurveyScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalQuestions = 4;
  
  // Store answers as indices (0-3)
  final List<int?> _answers = [null, null, null, null];
  bool _isAnalyzing = false;
  int? _resultProfileId; // 1-8

  // Target Vectors for the 8 Profiles
  // Format: [Frequency, Sleep, Tone, Feeling]
  // Values map to the option indices (0, 1, 2, 3)
  final Map<int, List<int>> _profileVectors = {
    1: [2, 2, 0, 3], // Hayalci Gezgin
    2: [1, 1, 1, 1], // Sessiz Gözlemci
    3: [3, 2, 1, 3], // Duygusal Kaşif
    4: [2, 1, 2, 2], // Zihinsel Savaşçı
    5: [3, 3, 0, 0], // Kontrolcü Mimar
    6: [1, 0, 3, 2], // Derin Dalgıç
    7: [2, 2, 0, 1], // Rüya Gezgini
    8: [3, 1, 2, 0], // Bilinç Eşiği Yolcusu
  };

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onOptionSelected(int answerIndex) {
    // Fix: _currentPage includes Welcome Screen (index 0). 
    // Questions start at index 1. So answer index is _currentPage - 1.
    setState(() {
      _answers[_currentPage - 1] = answerIndex;
    });

    if (_currentPage < _totalQuestions) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    } else {
      _calculateResult();
    }
  }

  Future<void> _calculateResult() async {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate analysis delay
    await Future.delayed(const Duration(seconds: 3));

    // Logic: Find closest profile using Euclidean distance
    int bestProfileId = 1;
    double minDistance = double.infinity;

    for (var entry in _profileVectors.entries) {
      int id = entry.key;
      List<int> vector = entry.value;
      
      double distance = 0;
      for (int i = 0; i < 4; i++) {
        // Safe check providing 0 if null (shouldn't be null here)
        int userVal = _answers[i] ?? 0;
        int targetVal = vector[i];
        distance += pow(userVal - targetVal, 2);
      }
      distance = sqrt(distance);

      if (distance < minDistance) {
        minDistance = distance;
        bestProfileId = id;
      }
    }

    // Save that user has completed onboarding
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding_survey', true);
    await prefs.setInt('user_dream_profile_id', bestProfileId);

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _resultProfileId = bestProfileId;
      });
    }
  }

  void _completeOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Define questions data structure inside build to access l10n
    final List<Map<String, dynamic>> questions = [
      {
        'question': l10n.surveyQ1,
        'options': [l10n.surveyQ1Option1, l10n.surveyQ1Option2, l10n.surveyQ1Option3, l10n.surveyQ1Option4]
      },
      {
        'question': l10n.surveyQ2,
        'options': [l10n.surveyQ2Option1, l10n.surveyQ2Option2, l10n.surveyQ2Option3, l10n.surveyQ2Option4]
      },
      {
        'question': l10n.surveyQ3,
        'options': [l10n.surveyQ3Option1, l10n.surveyQ3Option2, l10n.surveyQ3Option3, l10n.surveyQ3Option4] // Fixed typo in key if any, based on arb
      },
      {
        'question': l10n.surveyQ4,
        'options': [l10n.surveyQ4Option1, l10n.surveyQ4Option2, l10n.surveyQ4Option3, l10n.surveyQ4Option4]
      },
    ];

    if (_resultProfileId != null) {
      return _buildResultScreen(l10n);
    }

    if (_isAnalyzing) {
      return _buildAnalyzingScreen(l10n);
    }

    return NightSkyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _buildProgressBar(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: questions.length + 1, // +1 for Welcome Screen
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildWelcomeCard();
                    }
                    final q = questions[index - 1];
                    return _buildQuestionCard(
                      question: q['question'],
                      options: q['options'],
                      pageIndex: index - 1,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.welcomeHeader,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 32, // Main Header
                fontWeight: FontWeight.bold,
                color: Colors.purpleAccent.shade100,
                shadows: [
                   BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 15)
                ]
              ),
            ),
            const SizedBox(height: 48), // Increased from 24 to 48 for better separation
            Text(
              AppLocalizations.of(context)!.onboardingWelcomeTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 22, 
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.onboardingWelcomeSubtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 18,
                color: Colors.white70,
                height: 1.5
              ),
            ),
            const SizedBox(height: 60), // Space
            
            // Start Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: AppLocalizations.of(context)!.upgradeStart, // "Start"
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500), 
                    curve: Curves.easeInOut
                  );
                },
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8B5CF6), 
                    Color(0xFFD946EF)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80), // Push content slightly up for optical balance
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    // Hide progress bar on Welcome Screen (Page 0)
    if (_currentPage == 0) return const SizedBox.shrink();

    // Adjust current page for display (0-based index became 1-based questions)
    // _currentPage is raw page index (0=Welcome, 1=Q1...)
    // Display Step 1 for Page 1
    final displayStep = _currentPage; 
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white70),
                onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
              ),
              Text(
                AppLocalizations.of(context)!.stepProgress(displayStep, _totalQuestions),
                style: GoogleFonts.quicksand(color: Colors.white70, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 48), // Balance icon
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: displayStep / _totalQuestions,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard({required String question, required List<String> options, required int pageIndex}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          Text(
            question,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3
            ),
          ),
          const SizedBox(height: 40),
          ...List.generate(options.length, (index) {
            final isSelected = _answers[pageIndex] == index;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: InkWell(
                onTap: () => _onOptionSelected(index),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.purpleAccent.withOpacity(0.3) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Colors.purpleAccent : Colors.white.withOpacity(0.1),
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(color: Colors.purple.withOpacity(0.4), blurRadius: 10, spreadRadius: 1)
                    ] : [],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: isSelected ? Colors.purpleAccent : Colors.white54, width: 2),
                          color: isSelected ? Colors.purpleAccent : Colors.transparent,
                        ),
                        child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        options[index],
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnalyzingScreen(AppLocalizations l10n) {
    // Reuse background
    return NightSkyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MysticOrb(), // Replaced CircularProgressIndicator
              const SizedBox(height: 48), // Increased spacing
              Text(
                "Analiz ediliyor...", 
                style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen(AppLocalizations l10n) {
    // Map _resultProfileId to strings
    String name = "";
    String desc = "";
    
    // I could use a map, but switch is also fine
    switch (_resultProfileId) {
      case 1: name = l10n.profile1Name; desc = l10n.profile1Desc; break;
      case 2: name = l10n.profile2Name; desc = l10n.profile2Desc; break;
      case 3: name = l10n.profile3Name; desc = l10n.profile3Desc; break;
      case 4: name = l10n.profile4Name; desc = l10n.profile4Desc; break;
      case 5: name = l10n.profile5Name; desc = l10n.profile5Desc; break;
      case 6: name = l10n.profile6Name; desc = l10n.profile6Desc; break;
      case 7: name = l10n.profile7Name; desc = l10n.profile7Desc; break;
      case 8: name = l10n.profile8Name; desc = l10n.profile8Desc; break;
      default: name = l10n.profile1Name; desc = l10n.profile1Desc;
    }

    return NightSkyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView( // For smaller screens
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    l10n.surveyResultTitle,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      color: Colors.white70,
                      letterSpacing: 2
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.purpleAccent.shade100,
                      shadows: [
                        BoxShadow(color: Colors.purple.withOpacity(0.5), blurRadius: 20)
                      ]
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 20, offset: const Offset(0, 10))
                      ]
                    ),
                    child: Text(
                      desc,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.6
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Action Button
                  CustomButton(
                    text: l10n.surveyContinue,
                    onPressed: _completeOnboarding,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6366F1), // Indigo
                        Color(0xFFA855F7), // Purple
                        Color(0xFFEC4899), // Pink
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  Text(
                    l10n.surveyDisclaimer,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      color: Colors.white38,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
