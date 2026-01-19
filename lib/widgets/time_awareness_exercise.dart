import 'package:flutter/material.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';

class TimeAwarenessExercise extends StatefulWidget {
  const TimeAwarenessExercise({super.key});

  @override
  State<TimeAwarenessExercise> createState() => _TimeAwarenessExerciseState();
}

class _TimeAwarenessExerciseState extends State<TimeAwarenessExercise> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    // List of localized questions
    // User requested removal of Q3 ("What did you just do")
    final questions = [
      t.timeAwarenessQ1, // Date
      t.timeAwarenessQ2, // Day of Week (Changed from Year)
      // t.timeAwarenessQ3, // Removed
      t.timeAwarenessQ4, // Time
      t.timeAwarenessQ5, // 3 Objects
      t.timeAwarenessQ6, // Clothes
      t.timeAwarenessQ11, // Sounds (New 10th question)
      t.timeAwarenessQ7, // First person
      t.timeAwarenessQ8, // Hands
      t.timeAwarenessQ9, // Dreaming?
      t.timeAwarenessQ10, // Visualize
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C), // Dark card background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Column(
              children: [
                Text(
                  t.timeAwarenessTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFFBBF24), // Amber
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t.timeAwarenessInstruction,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Carousel
          SizedBox(
            height: 140, // Reduced from 180
            child: PageView.builder(
              controller: _pageController,
              itemCount: questions.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(16), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFBBF24).withOpacity(0.1),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    questions[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16, // Reduced from 18
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                );
              },
            ),
          ),

          // Golden Dots Indicator
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(questions.length, (index) {
                final isSelected = _currentIndex == index;
                // Only show a window of dots if we have many? 
                // For 10 dots, it fits but might be tight. Let's make them small.
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isSelected ? 8 : 6,
                  height: isSelected ? 8 : 6,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFBBF24) : Colors.white12,
                    shape: BoxShape.circle,
                    boxShadow: isSelected 
                        ? [BoxShadow(color: const Color(0xFFFBBF24).withOpacity(0.5), blurRadius: 4, spreadRadius: 1)] 
                        : null,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
