
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/widgets/gradient_text.dart';
import 'package:dream_boat_mobile/widgets/custom_button.dart';
import 'package:dream_boat_mobile/widgets/platform_widgets.dart';

class MoodSelectionSheet extends StatefulWidget {
  final Function(String mood, List<String> secondaryMoods, int intensity, int vividness) onSave;

  const MoodSelectionSheet({super.key, required this.onSave});

  @override
  State<MoodSelectionSheet> createState() => _MoodSelectionSheetState();
}

class _MoodSelectionSheetState extends State<MoodSelectionSheet> {
  String? _selectedMood;
  int _intensity = 2; // Medium default
  int _vividness = 2; // Medium default
  List<String> _secondaryMoods = [];
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    final moods = [
        {'key': 'love', 'label': t.moodLove, 'icon': LucideIcons.heart, 'color': const Color(0xFFEC4899)}, // Heart
        {'key': 'happy', 'label': t.moodHappy, 'icon': LucideIcons.sun, 'color': const Color(0xFFFBBF24)}, // Sun
        {'key': 'peace', 'label': t.moodPeace, 'icon': LucideIcons.feather, 'color': const Color(0xFF4ADE80)}, // Feather (Peace)
        {'key': 'awe', 'label': t.moodAwe, 'icon': LucideIcons.tornado, 'color': const Color(0xFFC084FC)}, // Tornado (Awe/Blown Away)
        {'key': 'empowered', 'label': t.moodEmpowered, 'icon': LucideIcons.zap, 'color': const Color(0xFFF43F5E)}, // Zap
        {'key': 'longing', 'label': t.moodLonging, 'icon': LucideIcons.cloudSun, 'color': const Color(0xFF38BDF8)}, // CloudSun (Horizon)
        {'key': 'confusion', 'label': t.moodConfusion, 'icon': LucideIcons.brain, 'color': const Color(0xFF2DD4BF)}, // Brain (Mental Confusion)
        {'key': 'anxiety', 'label': t.moodAnxiety, 'icon': LucideIcons.waves, 'color': const Color(0xFFFB923C)}, // Waves
        {'key': 'sad', 'label': t.moodSad, 'icon': LucideIcons.cloudRain, 'color': const Color(0xFF60A5FA)}, // CloudRain
        {'key': 'scared', 'label': t.moodScared, 'icon': LucideIcons.ghost, 'color': const Color(0xFF8B5CF6)}, // Ghost
        {'key': 'anger', 'label': t.moodAnger, 'icon': LucideIcons.flame, 'color': const Color(0xFFEF4444)}, // Flame
        {'key': 'neutral', 'label': t.moodNeutral, 'icon': LucideIcons.meh, 'color': const Color(0xFF9CA3AF)}, // Meh (Expressionless)
    ];

    // Calculate item width for 4 columns
    final double screenWidth = MediaQuery.of(context).size.width;
    final double paddingHorizontal = 48; // 24 + 24
    final double spacing = 12;
    final int columns = 4;
    final double itemWidth = (screenWidth - paddingHorizontal - (spacing * (columns - 1))) / columns;
    // Fixed height to accommodate 2 lines of text + icon + padding
    final double itemHeight = 100;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F23).withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: SingleChildScrollView(
          child: Padding(
             // Bottom padding for safe area
            padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 // Drag Handle
                 Center(
                   child: Container(
                     width: 40, height: 4,
                     decoration: BoxDecoration(
                       color: Colors.white.withOpacity(0.2),
                       borderRadius: BorderRadius.circular(2)
                     ),
                   ),
                 ),
                 const SizedBox(height: 24),
                 
                 // Vividness Slider Section
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                      Text(
                       t.moodVividnessQuestion,
                       style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                       textAlign: TextAlign.center,
                     ),
                   ],
                 ),
                 const SizedBox(height: 12),
                 Semantics(
                    label: t.moodVividnessQuestion,
                    value: _vividness == 1 ? t.moodVividnessLow : (_vividness == 2 ? t.moodVividnessMedium : t.moodVividnessHigh),
                    child: PlatformWidgets.adaptiveSlider(
                      value: _vividness.toDouble(),
                      min: 1, max: 3, divisions: 2,
                      activeColor: const Color(0xFFA78BFA),
                      label: _vividness == 1 ? t.moodVividnessLow : (_vividness == 2 ? t.moodVividnessMedium : t.moodVividnessHigh),
                      onChanged: (v) => setState(() => _vividness = v.round()),
                    ),
                  ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(t.moodVividnessLow, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)),
                     Text(t.moodVividnessHigh, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)),
                   ],
                 ),
                 const SizedBox(height: 32),

                 // Mood Prompt
                 GradientText(
                   t.moodSelectPrompt,
                   textAlign: TextAlign.center,
                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                   gradient: const LinearGradient(colors: [Colors.white, Color(0xFFE0E7FF)]),
                 ),
                 const SizedBox(height: 24),

                 // Mood Grid
                 Wrap(
                   spacing: spacing,
                   runSpacing: spacing,
                   alignment: WrapAlignment.start, // Align start to look like grid
                   children: moods.map((m) {
                     final isSelected = _selectedMood == m['key'];
                     final color = m['color'] as Color;
                     
                      return Semantics(
                        label: m['label'] as String,
                        hint: isSelected ? 'Selected' : 'Double tap to select',
                        button: true,
                        selected: isSelected,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedMood == m['key']) {
                                 // Deselect: tapping the same mood again clears selection
                                _selectedMood = null;
                              } else {
                                _selectedMood = m['key'] as String;
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic, 
                            width: itemWidth,
                            height: itemHeight,
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                            decoration: BoxDecoration(
                              // Unselected: Transparent with colored border
                              // Selected: Slight tint, colored border, glowing shadow
                              color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected ? color : color.withOpacity(0.3), // Colored border always
                                width: isSelected ? 1.5 : 1
                              ),
                              boxShadow: isSelected ? [
                                BoxShadow(color: color.withOpacity(0.6), blurRadius: 12, spreadRadius: -2), // Inner/Outer Glow
                                BoxShadow(color: color.withOpacity(0.3), blurRadius: 20, spreadRadius: 2), // Outer Haze
                              ] : [],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon: Color always, slightly dim when not selected
                                Icon(
                                  m['icon'] as IconData, 
                                  color: isSelected ? color : color.withOpacity(0.8), 
                                  size: 26
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  m['label'] as String,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : color.withOpacity(0.8), // Text colored when unselected
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 11, // Slightly smaller to fit 2 lines
                                    letterSpacing: 0.3,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                   }).toList(),
                 ),
               
               // Intensity Slider (Only if mood selected)
               AnimatedSize(
                 duration: const Duration(milliseconds: 300),
                 child: _selectedMood != null ? Column(
                   children: [
                     const SizedBox(height: 32),
                     Text(
                       t.moodIntensityLabel,
                       style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
                     ),
                     const SizedBox(height: 8),
                      Semantics(
                        label: t.moodIntensityLabel,
                        value: _intensity == 1 ? t.moodIntensityLow : (_intensity == 2 ? t.moodIntensityMedium : t.moodIntensityHigh),
                        child: PlatformWidgets.adaptiveSlider(
                          value: _intensity.toDouble(),
                          min: 1, max: 3, divisions: 2,
                          activeColor: moods.firstWhere((m) => m['key'] == _selectedMood)['color'] as Color,
                          label: _intensity == 1 ? t.moodIntensityLow : (_intensity == 2 ? t.moodIntensityMedium : t.moodIntensityHigh),
                          onChanged: (v) => setState(() => _intensity = v.round()),
                        ),
                      ),
                      Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(t.moodIntensityLow, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)),
                         Text(t.moodIntensityHigh, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)),
                       ],
                     ),
                     const SizedBox(height: 24),
                     // Save Button
                     SizedBox(
                       width: double.infinity,
                       child: CustomButton(
                         text: t.newDreamSave, // Reuse or "Continue"
                         onPressed: () {
                           if (_selectedMood != null) {
                             widget.onSave(_selectedMood!, _secondaryMoods, _intensity, _vividness);
                           }
                         },
                         gradient: LinearGradient(
                           colors: [
                             moods.firstWhere((m) => m['key'] == _selectedMood)['color'] as Color,
                             (moods.firstWhere((m) => m['key'] == _selectedMood)['color'] as Color).withOpacity(0.7)
                           ],
                         ),
                       ),
                     ),
                   ],
                 ) : const SizedBox.shrink(),
               ),
               
               if (_selectedMood == null) ...[
                 const SizedBox(height: 32),
                 TextButton(
                   onPressed: () {
                      widget.onSave('neutral', [], 1, _vividness);
                   },
                   child: Text(t.moodNotSure, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                 ),
               ],
               
               const SizedBox(height: 20), // Bottom SafeArea buffer
            ],
          ),
        ),
      ),
      ),
    );
  }
}
