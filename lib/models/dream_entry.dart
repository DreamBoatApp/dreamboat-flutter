import 'dart:convert';

class DreamEntry {
  final String id;
  final String text;
  final DateTime date;
  final String mood;
  final String interpretation;
  final String? title; // AI-generated dream title
  final bool isFavorite;

  DreamEntry({
    required this.id,
    required this.text,
    required this.date,
    required this.mood,
    required this.interpretation,
    this.title,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'date': date.toIso8601String(),
      'mood': mood,
      'interpretation': interpretation,
      'title': title,
      'isFavorite': isFavorite,
    };
  }

  factory DreamEntry.fromJson(Map<String, dynamic> json) {
    return DreamEntry(
      id: json['id'],
      text: json['text'],
      date: DateTime.parse(json['date']),
      mood: json['mood'],
      interpretation: json['interpretation'] ?? '',
      title: json['title'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  DreamEntry copyWith({
    String? id,
    String? text,
    DateTime? date,
    String? mood,
    String? interpretation,
    String? title,
    bool? isFavorite,
  }) {
    return DreamEntry(
      id: id ?? this.id,
      text: text ?? this.text,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      interpretation: interpretation ?? this.interpretation,
      title: title ?? this.title,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
