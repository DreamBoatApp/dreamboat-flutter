import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dream_boat_mobile/models/dream_entry.dart';

class DreamService {
  static const String _storageKey = 'dreams_data';

  Future<List<DreamEntry>> getDreams() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dreamsJson = prefs.getString(_storageKey);
    if (dreamsJson == null) return [];

    final List<dynamic> decoded = jsonDecode(dreamsJson);
    return decoded.map((e) => DreamEntry.fromJson(e)).toList();
  }

  Future<void> saveDream(DreamEntry dream) async {
    final dreams = await getDreams();
    dreams.insert(0, dream); // Add new dream to the top
    await _saveList(dreams);
  }

  Future<void> deleteDream(String id) async {
    final dreams = await getDreams();
    dreams.removeWhere((element) => element.id == id);
    await _saveList(dreams);
  }

  Future<void> updateDream(DreamEntry updatedDream) async {
    final dreams = await getDreams();
    final index = dreams.indexWhere((element) => element.id == updatedDream.id);
    if (index != -1) {
      dreams[index] = updatedDream;
      await _saveList(dreams);
    }
  }

  Future<void> toggleFavorite(String id) async {
    final dreams = await getDreams();
    final index = dreams.indexWhere((element) => element.id == id);
    if (index != -1) {
      final old = dreams[index];
      dreams[index] = old.copyWith(isFavorite: !old.isFavorite);
      await _saveList(dreams);
    }
  }

  static const String _firstDreamKey = 'is_first_dream_used';

  Future<bool> isFirstDream() async {
    final prefs = await SharedPreferences.getInstance();
    // Default to true (first dream NOT used yet)
    // If key exists and is true, it means used.
    // Wait, let's allow "isFirst" meaning "Am I treated as first?". 
    // If key is missing, it is first.
    final used = prefs.getBool(_firstDreamKey) ?? false;
    return !used;
  }

  Future<void> setFirstDreamUsed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstDreamKey, true);
  }

  Future<void> _saveList(List<DreamEntry> dreams) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(dreams.map((e) => e.toJson()).toList());
    print("MyDream: Persisting ${dreams.length} dreams to storage.");
    await prefs.setString(_storageKey, encoded);
  }

  // --- Daily Usage Logic ---
  static const String _dailyUsageDateKey = 'daily_usage_date';
  static const String _dailyUsageCountKey = 'daily_usage_count';

  Future<int> getDailyUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD
    final lastDate = prefs.getString(_dailyUsageDateKey);

    if (lastDate != today) {
      // New day, reset
      await prefs.setString(_dailyUsageDateKey, today);
      await prefs.setInt(_dailyUsageCountKey, 0);
      return 0;
    }

    return prefs.getInt(_dailyUsageCountKey) ?? 0;
  }

  Future<void> incrementDailyUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final count = await getDailyUsage(); // Ensures date is effectively checked/reset
    await prefs.setInt(_dailyUsageCountKey, count + 1);
  }
}
