import 'package:hive/hive.dart';
import 'dart:convert';

part 'dream_entry.g.dart';

@HiveType(typeId: 0)
class DreamEntry {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final String mood;
  @HiveField(13)
  final String? cosmicAnalysis; // Content from Journal API
  @HiveField(4)
  final List<String>? secondaryMoods;
  @HiveField(5)
  final int? moodIntensity; // 1: Low, 2: Medium, 3: High
  @HiveField(6)
  final int? vividness; // 1: Vague, 2: Partial, 3: Clear
  @HiveField(7)
  final String interpretation;
  @HiveField(8)
  final String? title; // AI-generated dream title
  @HiveField(9)
  final bool isFavorite;
  @HiveField(10)
  final List<String>? astronomicalEvents; // List of cosmic events (e.g., "Super Moon", "Solar Eclipse")
  @HiveField(11)
  final int? guideStage; // Lucid guide stage when dream was recorded (0: MILD, 1: WBTB, 2: WILD, etc.)
  @HiveField(12)
  final String? imageUrl; // DALL-E 3 Image (Firebase Storage URL)

  DreamEntry({
    required this.id,
    required this.text,
    required this.date,
    required this.mood,
    this.secondaryMoods,
    this.moodIntensity,
    this.vividness,
    required this.interpretation,
    this.title,
    this.isFavorite = false,
    this.astronomicalEvents,
    this.guideStage,
    this.imageUrl,
    this.cosmicAnalysis,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'date': date.toIso8601String(),
      'mood': mood,
      'secondaryMoods': secondaryMoods,
      'moodIntensity': moodIntensity,
      'vividness': vividness,
      'interpretation': interpretation,
      'title': title,
      'isFavorite': isFavorite,
      'astronomicalEvents': astronomicalEvents,
      'guideStage': guideStage,
      'imageUrl': imageUrl,
      'cosmicAnalysis': cosmicAnalysis,
    };
  }

  factory DreamEntry.fromJson(Map<String, dynamic> json) {
    // Parse date with fallback
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['date'] ?? '');
    } catch (e) {
      parsedDate = DateTime.now(); // Fallback to current date if parsing fails
    }
    
    return DreamEntry(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: json['text']?.toString() ?? '',
      date: parsedDate,
      mood: json['mood']?.toString() ?? 'neutral',
      secondaryMoods: (json['secondaryMoods'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      moodIntensity: json['moodIntensity'] as int?,
      vividness: json['vividness'] as int?,
      interpretation: json['interpretation']?.toString() ?? '',
      title: json['title']?.toString(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      astronomicalEvents: (json['astronomicalEvents'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      guideStage: json['guideStage'] as int?,
      imageUrl: json['imageUrl']?.toString(),
      cosmicAnalysis: json['cosmicAnalysis']?.toString(),
    );
  }

  DreamEntry copyWith({
    String? id,
    String? text,
    DateTime? date,
    String? mood,
    List<String>? secondaryMoods,
    int? moodIntensity,
    int? vividness,
    String? interpretation,
    String? title,
    bool? isFavorite,
    List<String>? astronomicalEvents,
    int? guideStage,
    String? imageUrl,
    String? cosmicAnalysis,
  }) {
    return DreamEntry(
      id: id ?? this.id,
      text: text ?? this.text,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      secondaryMoods: secondaryMoods ?? this.secondaryMoods,
      moodIntensity: moodIntensity ?? this.moodIntensity,
      vividness: vividness ?? this.vividness,
      interpretation: interpretation ?? this.interpretation,
      title: title ?? this.title,
      isFavorite: isFavorite ?? this.isFavorite,
      astronomicalEvents: astronomicalEvents ?? this.astronomicalEvents,
      guideStage: guideStage ?? this.guideStage,
      imageUrl: imageUrl ?? this.imageUrl,
      cosmicAnalysis: cosmicAnalysis ?? this.cosmicAnalysis,
    );
  }
}

