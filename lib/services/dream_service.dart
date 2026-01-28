import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dream_boat_mobile/models/dream_entry.dart';

class DreamService {
  static const String _boxName = 'dreams';

  /// Get the open box. It must be opened in main.dart before accessing this.
  Box<DreamEntry> get _box => Hive.box<DreamEntry>(_boxName);

  Future<List<DreamEntry>> getDreams() async {
    // Hive keeps data in memory, so values.toList() is fast.
    // We sort them by date descending (newest first)
    final dreams = _box.values.toList();
    dreams.sort((a, b) => b.date.compareTo(a.date));
    return dreams;
  }

  Future<void> saveDream(DreamEntry dream) async {
    // We use the ID as the key for O(1) lookups
    await _box.put(dream.id, dream);
    debugPrint("DreamService (Hive): Saved dream ${dream.id}");
  }

  Future<void> deleteDream(String id) async {
    await _box.delete(id);
    debugPrint("DreamService (Hive): Deleted dream $id");
  }

  Future<void> updateDream(DreamEntry updatedDream) async {
    // In Hive, 'put' updates if key exists
    await _box.put(updatedDream.id, updatedDream);
    debugPrint("DreamService (Hive): Updated dream ${updatedDream.id}");
  }

  Future<void> toggleFavorite(String id) async {
    final dream = _box.get(id);
    if (dream != null) {
      final updated = dream.copyWith(isFavorite: !dream.isFavorite);
      await _box.put(id, updated);
    }
  }

  // --- First Dream Logic (Still using SharedPrefs for simple flags) ---
  static const String _firstDreamKey = 'is_first_dream_used';

  Future<bool> isFirstDream() async {
    final prefs = await SharedPreferences.getInstance();
    final used = prefs.getBool(_firstDreamKey) ?? false;
    return !used;
  }

  Future<void> setFirstDreamUsed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstDreamKey, true);
  }

  // --- Daily Usage Logic (Still using SharedPrefs for ephemeral limits) ---
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
    final count = await getDailyUsage(); 
    await prefs.setInt(_dailyUsageCountKey, count + 1);
  }
}
