import 'package:flutter/material.dart';
import 'dart:io';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/satisfaction_modal.dart';
import '../widgets/feedback_modal.dart';

class ReviewService {
  static const String _kLastReviewRequestDate = 'last_review_request_date';
  static const String _kReviewOutcome = 'last_review_outcome'; // 'dismissed', 'interacted'
  static const String _kLoginStreak = 'login_streak_days';
  static const String _kLastLoginDate = 'last_login_date';

  // Cooldown periods
  static const int _fullCooldownDays = 30; // For users who interacted (rated/gave feedback)
  static const int _dismissedCooldownDays = 3; // For users who dismissed without interaction

  /// Checks if the user is eligible for a review request based on last outcome.
  static Future<bool> isReviewPeriodEligible() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRequestTs = prefs.getInt(_kLastReviewRequestDate);

    if (lastRequestTs == null) return true;

    final lastRequestDate = DateTime.fromMillisecondsSinceEpoch(lastRequestTs);
    final difference = DateTime.now().difference(lastRequestDate).inDays;

    // Get last outcome to determine cooldown period
    final lastOutcome = prefs.getString(_kReviewOutcome) ?? 'dismissed';
    
    if (lastOutcome == 'interacted') {
      // User rated or gave feedback - full 30 day cooldown
      return difference >= _fullCooldownDays;
    } else {
      // User dismissed - shorter 3 day cooldown
      return difference >= _dismissedCooldownDays;
    }
  }

  /// Updates the last review request date with outcome type.
  static Future<void> _updateLastReviewRequestDate({required String outcome}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kLastReviewRequestDate, DateTime.now().millisecondsSinceEpoch);
    await prefs.setString(_kReviewOutcome, outcome);
    debugPrint('ReviewService: Cooldown updated with outcome: $outcome');
  }

  /// Main method to trigger the review flow.
  /// Shows SatisfactionModal first.
  static Future<void> triggerReviewFlow(BuildContext context) async {
    // 1. Check eligibility
    if (!await isReviewPeriodEligible()) {
      debugPrint('ReviewService: Not eligible for review yet (cooldown active).');
      return;
    }

    // NOTE: We no longer mark as requested immediately.
    // We update cooldown AFTER user interaction with appropriate outcome.

    // 2. Platform-specific flow
    
    // iOS: Native Prompt Directly (Apple Requirement/Best Practice)
    if (Platform.isIOS) {
      final InAppReview inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        // Treat as 'interacted' to enforce the full 30-day cooldown
        await _updateLastReviewRequestDate(outcome: 'interacted');
      }
      return;
    }

    // Android: Custom Satisfaction Flow
    if (!context.mounted) return;
    
    final dialogResult = await showDialog<String>(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (ctx) => SatisfactionModal(
        onSatisfied: () async {
          Navigator.of(ctx).pop('satisfied'); // Return result
          
          // 3a. Positive: Request In-App Review
          final InAppReview inAppReview = InAppReview.instance;

          if (await inAppReview.isAvailable()) {
            await inAppReview.requestReview();
          }
          
          // Mark as interacted - full cooldown
          await _updateLastReviewRequestDate(outcome: 'interacted');
        },
        onNeutralOrNegative: () async {
          Navigator.of(ctx).pop('feedback'); // Return result
          
          // 3b. Negative/Neutral: Show Feedback Modal
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (c) => const FeedbackModal(),
            );
          }
          
          // Mark as interacted - full cooldown
          await _updateLastReviewRequestDate(outcome: 'interacted');
        },
      ),
    );

    // User dismissed dialog (tapped outside or pressed back)
    if (dialogResult == null && context.mounted) {
      // Short cooldown - ask again in 3 days
      await _updateLastReviewRequestDate(outcome: 'dismissed');
      debugPrint('ReviewService: Dialog dismissed, will ask again in $_dismissedCooldownDays days');
    }
  }

  /// Helper to track login streaks. Call this on app start.
  static Future<void> recordLoginAndCheckStreak(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final lastLoginTs = prefs.getInt(_kLastLoginDate);
    final currentStreak = prefs.getInt(_kLoginStreak) ?? 0;

    if (lastLoginTs == null) {
      // First ever login
      await prefs.setInt(_kLastLoginDate, today.millisecondsSinceEpoch);
      await prefs.setInt(_kLoginStreak, 1);
      return;
    }

    final lastLoginDate = DateTime.fromMillisecondsSinceEpoch(lastLoginTs);
    final lastLoginDay = DateTime(lastLoginDate.year, lastLoginDate.month, lastLoginDate.day);
    
    final difference = today.difference(lastLoginDay).inDays;

    if (difference == 0) {
      // Same day login, do nothing
      return;
    } else if (difference == 1) {
      // Consecutive day
      final newStreak = currentStreak + 1;
      await prefs.setInt(_kLoginStreak, newStreak);
      await prefs.setInt(_kLastLoginDate, today.millisecondsSinceEpoch);

      // Trigger if streak hits exactly 3
      if (newStreak == 3) {
        if (context.mounted) {
          triggerReviewFlow(context);
        }
      }
    } else {
      // Streak broken
      await prefs.setInt(_kLoginStreak, 1);
      await prefs.setInt(_kLastLoginDate, today.millisecondsSinceEpoch);
    }
  }
}
