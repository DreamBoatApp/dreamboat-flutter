
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<String> _selectedMoods = [];
  int _intensity = 3; // Medium default (Scale 1-5)
  int _vividness = 3; // Medium default (Scale 1-5)
  bool _isSaving = false;

  void _toggleMood(String key) {
    setState(() {
      if (_selectedMoods.contains(key)) {
        _selectedMoods.remove(key);
      } else {
        if (_selectedMoods.length >= 2) {
          _selectedMoods.removeAt(0); // FIFO: Remove first selected
        }
        _selectedMoods.add(key);
      }
      HapticFeedback.selectionClick();
    });
  }

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

    Color getActiveColor() {
      if (_selectedMoods.isEmpty) return const Color(0xFFA78BFA);
      if (_selectedMoods.length == 1) {
        return moods.firstWhere((m) => m['key'] == _selectedMoods.first)['color'] as Color;
      }
      final color1 = moods.firstWhere((m) => m['key'] == _selectedMoods[0])['color'] as Color;
      final color2 = moods.firstWhere((m) => m['key'] == _selectedMoods[1])['color'] as Color;
      return Color.lerp(color1, color2, 0.5)!;
    }

    return Container(
      // ... (decoration remains same) ...
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
                    value: _vividness == 1 ? t.moodVividnessLow : (_vividness == 3 ? t.moodVividnessMedium : (_vividness == 5 ? t.moodVividnessHigh : '')),
                    child: SliderTheme(
                       data: SliderTheme.of(context).copyWith(
                         trackHeight: 4,
                         activeTrackColor: const Color(0xFFA78BFA),
                         inactiveTrackColor: Colors.white.withOpacity(0.1),
                         thumbColor: Colors.white,
                         thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                         overlayColor: const Color(0xFFA78BFA).withOpacity(0.2),
                         overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                         tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 5), // Even larger
                         activeTickMarkColor: Colors.white, // Fully opaque white for maximum contrast
                         inactiveTickMarkColor: Colors.white.withOpacity(0.3),
                       ),
                       child: Platform.isIOS 
                         ? PlatformWidgets.adaptiveSlider(
                             value: _vividness.toDouble(),
                             min: 1, max: 5, divisions: 4,
                             activeColor: const Color(0xFFA78BFA),
                             label: _vividness == 1 ? t.moodVividnessLow : (_vividness == 3 ? t.moodVividnessMedium : (_vividness == 5 ? t.moodVividnessHigh : '')),
                             onChanged: (v) {
                               if (v.round() != _vividness) {
                                 HapticFeedback.selectionClick();
                                 setState(() => _vividness = v.round());
                               }
                             },
                           )
                         : Slider(
                             value: _vividness.toDouble(),
                             min: 1, max: 5, divisions: 4,
                             // Note: We DO NOT pass activeColor here for Android to ensure SliderTheme colors (including tick marks) are respected
                             inactiveColor: Colors.white.withOpacity(0.1),
                             label: _vividness == 1 ? t.moodVividnessLow : (_vividness == 3 ? t.moodVividnessMedium : (_vividness == 5 ? t.moodVividnessHigh : '')),
                             onChanged: (v) {
                               if (v.round() != _vividness) {
                                 HapticFeedback.selectionClick();
                                 setState(() => _vividness = v.round());
                               }
                             },
                           ),
                     ),
                  ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Expanded(child: Text(t.moodVividnessLow, textAlign: TextAlign.left, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12))),
                     Expanded(child: Text(t.moodVividnessMedium, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12))),
                     Expanded(child: Text(t.moodVividnessHigh, textAlign: TextAlign.right, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12))),
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
                 LayoutBuilder(
                   builder: (context, constraints) {
                     // Calculate item width for 4 columns
                     // Padding: 24 (left) + 24 (right) = 48
                     // Spacing: 12 * 3 = 36
                     // Available Width for items = ScreenWidth - 48 - 36 (actually we use constraints.maxWidth which already accounts for padding)
                     
                     // Since we are inside Padding(24), constraints.maxWidth is (ScreenWidth - 48)
                     // We need 4 items with 3 gaps of 12px
                     final itemWidth = (constraints.maxWidth - (12 * 3)) / 4;
                     final itemHeight = itemWidth * 1.3; // Slight vertical rectangle aspect ratio
                     
                     return Wrap(
                       spacing: 12,
                       runSpacing: 12,
                       alignment: WrapAlignment.start, // Align to grid
                       children: moods.map((mood) {
                         final isSelected = _selectedMoods.contains(mood['key']);
                         final color = mood['color'] as Color;
                         
                         return GestureDetector(
                           onTap: () => _toggleMood(mood['key'] as String),
                           child: AnimatedContainer(
                             duration: const Duration(milliseconds: 200),
                             width: itemWidth,
                             height: itemHeight,
                             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                             decoration: BoxDecoration(
                               color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
                               borderRadius: BorderRadius.circular(20),
                               border: Border.all(
                                 color: isSelected ? color : color.withOpacity(0.3),
                                 width: isSelected ? 1.5 : 1
                               ),
                               boxShadow: isSelected ? [
                                 BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, spreadRadius: 1)
                               ] : []
                             ),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(mood['icon'] as IconData, size: 24, color: color),
                                 const SizedBox(height: 8),
                                 Text(
                                   mood['label'] as String,
                                   textAlign: TextAlign.center,
                                   maxLines: 2,
                                   overflow: TextOverflow.visible, // Allow wrap
                                   style: TextStyle(
                                     color: color,
                                     fontSize: 10, // Slightly smaller to fit "Kafa Karışıklığı"
                                     height: 1.1,
                                     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                                   ),
                                 )
                               ],
                             ),
                           ),
                         );
                       }).toList(),
                     );
                   }
                 ),
                 
                 // Intensity Slider (Only if mood selected)
               AnimatedSize(
                 duration: const Duration(milliseconds: 300),
                 child: _selectedMoods.isNotEmpty ? Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     const SizedBox(height: 32),
                     Text(
                       t.moodIntensityLabel,
                       textAlign: TextAlign.center,
                       style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
                     ),
                     const SizedBox(height: 8),
                      Semantics(
                        label: t.moodIntensityLabel,
                        value: _intensity == 1 ? t.moodIntensityLow : (_intensity == 3 ? t.moodIntensityMedium : (_intensity == 5 ? t.moodIntensityHigh : '')),
                        child: SliderTheme(
                           data: SliderTheme.of(context).copyWith(
                             trackHeight: 4,
                             activeTrackColor: getActiveColor(),
                             inactiveTrackColor: Colors.white.withOpacity(0.1),
                             thumbColor: Colors.white,
                             thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                             overlayColor: getActiveColor().withOpacity(0.2),
                             overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                             tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 5), // Even larger
                             activeTickMarkColor: Colors.white, // Fully opaque white for maximum contrast
                             inactiveTickMarkColor: Colors.white.withOpacity(0.3),
                             valueIndicatorColor: getActiveColor(), // Match bubble color to mood
                             valueIndicatorTextStyle: const TextStyle(color: Colors.white),
                           ),
                           child: Platform.isIOS 
                             ? PlatformWidgets.adaptiveSlider(
                                 value: _intensity.toDouble(),
                                 min: 1, max: 5, divisions: 4,
                                 activeColor: getActiveColor(),
                                 label: _intensity == 1 ? t.moodIntensityLow : (_intensity == 3 ? t.moodIntensityMedium : (_intensity == 5 ? t.moodIntensityHigh : '')),
                                 onChanged: (v) {
                                   if (v.round() != _intensity) {
                                     HapticFeedback.selectionClick();
                                     setState(() => _intensity = v.round());
                                   }
                                 },
                               )
                             : Slider(
                                 value: _intensity.toDouble(),
                                 min: 1, max: 5, divisions: 4,
                                 // Note: We DO NOT pass activeColor here for Android to ensure SliderTheme colors (including tick marks) are respected
                                 inactiveColor: Colors.white.withOpacity(0.1),
                                 label: _intensity == 1 ? t.moodIntensityLow : (_intensity == 3 ? t.moodIntensityMedium : (_intensity == 5 ? t.moodIntensityHigh : '')),
                                 onChanged: (v) {
                                   if (v.round() != _intensity) {
                                     HapticFeedback.selectionClick();
                                     setState(() => _intensity = v.round());
                                   }
                                 },
                               ),
                        ),
                      ),
                      Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Expanded(child: Text(t.moodIntensityLow, textAlign: TextAlign.left, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12))),
                         Expanded(child: Text(t.moodIntensityMedium, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12))),
                         Expanded(child: Text(t.moodIntensityHigh, textAlign: TextAlign.right, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12))),
                       ],
                     ),
                     const SizedBox(height: 24),
                     // Save Button
                     SizedBox(
                       width: double.infinity,
                       child: CustomButton(
                         text: t.newDreamSave, 
                         onPressed: () {
                           if (_selectedMoods.isNotEmpty) {
                             final primary = _selectedMoods.first;
                             final secondary = _selectedMoods.length > 1 ? _selectedMoods.sublist(1) : <String>[];
                             widget.onSave(primary, secondary, _intensity, _vividness);
                           }
                         },
                         gradient: LinearGradient(
                           colors: [
                             getActiveColor(),
                             getActiveColor().withOpacity(0.7)
                           ],
                         ),
                       ),
                     ),
                   ],
                 ) : const SizedBox.shrink(),
               ),
               
               if (_selectedMoods.isEmpty) ...[
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
