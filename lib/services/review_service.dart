import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/satisfaction_modal.dart';
import '../widgets/feedback_modal.dart';

class ReviewService {
  static const String _kLastReviewRequestDate = 'last_review_request_date';
  static const String _kLoginStreak = 'login_streak_days';
  static const String _kLastLoginDate = 'last_login_date';

  /// Checks if the user is eligible for a review request (e.g., once per month).
  static Future<bool> isReviewPeriodEligible() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRequestTs = prefs.getInt(_kLastReviewRequestDate);

    if (lastRequestTs == null) return true;

    final lastRequestDate = DateTime.fromMillisecondsSinceEpoch(lastRequestTs);
    final difference = DateTime.now().difference(lastRequestDate).inDays;

    return difference >= 30; // 30 days cooldown
  }

  /// Updates the last review request date to now.
  static Future<void> _updateLastReviewRequestDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kLastReviewRequestDate, DateTime.now().millisecondsSinceEpoch);
  }

  /// Main method to trigger the review flow.
  /// Shows SatisfactionModal first.
  static Future<void> triggerReviewFlow(BuildContext context) async {
    // 1. Check eligibility
    if (!await isReviewPeriodEligible()) {
      debugPrint('ReviewService: Not eligible for review yet (cooldown active).');
      return;
    }

    // Mark as requested immediately so we don't ask again for a month, 
    // regardless of whether they interact or dismiss the dialog.
    await _updateLastReviewRequestDate();

    // 2. Show Satisfaction Modal
    if (!context.mounted) return;
    
    showDialog(
      context: context,
      builder: (ctx) => SatisfactionModal(
        onSatisfied: () async {
          Navigator.of(ctx).pop(); // Close modal
          
          // 3a. Positive: Request In-App Review
          final InAppReview inAppReview = InAppReview.instance;

          if (await inAppReview.isAvailable()) {
            await inAppReview.requestReview();
          } else {
             // Fallback to store listing if needed
          }
        },
        onNeutralOrNegative: () async {
          Navigator.of(ctx).pop(); // Close modal
          
          // 3b. Negative/Neutral: Show Feedback Modal
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (c) => const FeedbackModal(),
            );
          }
          
          // Still mark as requested to avoid pestering
          await _updateLastReviewRequestDate();
        },
      ),
    );
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
