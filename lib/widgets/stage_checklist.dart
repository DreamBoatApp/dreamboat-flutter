import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class StageChecklist extends StatefulWidget {
  final Map<String, int> tasks; // Task Key -> Total Stars
  final Map<String, int> progress; // Task Key -> Current Stars
  final Map<String, String> taskTitles; // Task Key -> Localized Title
  final Function(String taskKey, int stars) onProgressChanged;

  const StageChecklist({
    super.key,
    required this.tasks,
    required this.progress,
    required this.taskTitles,
    required this.onProgressChanged,
  });

  @override
  State<StageChecklist> createState() => _StageChecklistState();
}

class _StageChecklistState extends State<StageChecklist> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.tasks.entries.map((entry) {
        final taskKey = entry.key;
        final totalStars = entry.value;
        final currentStars = widget.progress[taskKey] ?? 0;
        final displayTitle = widget.taskTitles[taskKey] ?? taskKey;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(totalStars, (index) {
                  final isFilled = index < currentStars;
                  return GestureDetector(
                    onTap: () {
                      int newStars = currentStars;
                      if (index < currentStars) {
                        // Tapping on a filled star (or before it)
                        // If we tap the last filled star, remove it.
                        // If we tap an earlier star, maybe set to that level?
                        // User request: "tap to add, tap again to remove" (toggle-ish logic)
                        // Standard rating logic: set to index + 1.
                        // But if we click the exact level we are at, maybe clear it?
                        // Let's implement: Click index N -> Set level to N+1.
                        // If level is already N+1, set to N.
                        
                        if (index == currentStars - 1) {
                           newStars = index; // Remove last star
                        } else {
                           newStars = index + 1; // Update to this level
                        }
                      } else {
                        // Tapping on empty star -> fill up to this one
                        newStars = index + 1;
                      }
                      
                      widget.onProgressChanged(taskKey, newStars);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(4),
                       decoration: BoxDecoration(
                        color: isFilled ? const Color(0xFFFBBF24) : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isFilled ? const Color(0xFFFBBF24) : Colors.white.withOpacity(0.3),
                          width: 1.5
                        ),
                        boxShadow: isFilled ? [
                          BoxShadow(
                            color: const Color(0xFFFBBF24).withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 1
                          )
                        ] : null
                      ),
                      child: Icon(
                        LucideIcons.star,
                        size: 16,
                        color: isFilled ? Colors.black : Colors.white.withOpacity(0.3),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
