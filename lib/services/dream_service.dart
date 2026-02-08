import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dream_boat_mobile/models/dream_entry.dart';
import 'package:dream_boat_mobile/services/openai_service.dart'; // Reuse init logic if possible

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

  // --- Weekly Usage Logic (Tracking Only - Limit Enforcement DISABLED) ---
  // Unit economics: Video ad revenue ($0.003-0.008) >> API cost ($0.0006) = 5-13x margin
  // Tracking preserved for analytics; limit enforcement removed from new_dream_screen.dart
  static const String _weeklyUsageStartKey = 'weekly_usage_start';
  static const String _weeklyUsageCountKey = 'weekly_usage_count';
  @Deprecated('Limit enforcement disabled. Constant kept for reference.')
  static const int weeklyFreeLimit = 3; // No longer enforced

  /// Returns the number of interpretations used in the active 7-day period.
  Future<int> getWeeklyUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final startStr = prefs.getString(_weeklyUsageStartKey);
    
    DateTime? start;
    if (startStr != null) {
      start = DateTime.tryParse(startStr);
    }
    
    // Check if 7 days passed or no start date
    if (start == null || now.difference(start).inDays >= 7) {
      // Reset period
      await prefs.setString(_weeklyUsageStartKey, now.toIso8601String());
      await prefs.setInt(_weeklyUsageCountKey, 0);
      return 0;
    }
    
    return prefs.getInt(_weeklyUsageCountKey) ?? 0;
  }

  Future<void> incrementWeeklyUsage() async {
     // Ensure period validity
     await getWeeklyUsage(); 
     final prefs = await SharedPreferences.getInstance();
     final count = prefs.getInt(_weeklyUsageCountKey) ?? 0;
     await prefs.setInt(_weeklyUsageCountKey, count + 1);
  }

  // --- Image Generation ---
  Future<String> generateImage({
    required String dreamId,
    required String dreamText,
    required bool isTrial,
  }) async {
    try {
      // 1. Ensure Firebase/Auth (OpenAIService has helper, but we call direct here)
      // We assume user is authenticated if they are in the app
      
      final result = await FirebaseFunctions.instance.httpsCallable('generateDreamImage').call({
        'dreamText': dreamText,
        'dreamId': dreamId,
        'isTrial': isTrial,
        'isDebug': kDebugMode, // Bypass limits on Emulator/Debug
      }).timeout(const Duration(seconds: 60)); // DALL-E takes ~15s
      
      final data = result.data as Map<String, dynamic>;
      final imageUrl = data['imageUrl'] as String;

      // 2. Save to Local Storage (Hive)
      final dream = _box.get(dreamId);
      if (dream != null) {
        final updatedDream = dream.copyWith(imageUrl: imageUrl);
        await updateDream(updatedDream);
      }
      
      return imageUrl;
    } on FirebaseFunctionsException catch (e) {
      debugPrint('Cloud Function Error: ${e.code} - ${e.message}');
      throw e; // Rethrow to show UI dialog
    } catch (e) {
      debugPrint('Generator Error: $e');
      throw e;
    }
  }
}
