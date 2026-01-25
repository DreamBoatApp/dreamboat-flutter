import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Platform-aware widgets for iOS HIG compliance
/// All widgets automatically adapt to iOS Cupertino style while
/// maintaining Material Design on Android
class PlatformWidgets {
  /// Platform-aware activity indicator
  /// Returns CupertinoActivityIndicator on iOS, CircularProgressIndicator on Android
  static Widget activityIndicator({
    Color? color,
    double radius = 14,
    double strokeWidth = 2,
  }) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(
        radius: radius,
        color: color,
      );
    }
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: color != null ? AlwaysStoppedAnimation(color) : null,
      ),
    );
  }

  /// Platform-aware switch
  /// Returns CupertinoSwitch on iOS, Switch on Android
  static Widget adaptiveSwitch({
    required bool value,
    required ValueChanged<bool>? onChanged,
    Color? activeColor,
  }) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        value: value,
        activeTrackColor: activeColor,
        onChanged: onChanged,
      );
    }
    return Switch(
      value: value,
      activeColor: activeColor,
      onChanged: onChanged,
    );
  }

  /// Platform-aware confirmation dialog
  /// Shows CupertinoAlertDialog on iOS, Material Dialog on Android
  static Future<bool?> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
    bool isDestructive = false,
    Color? destructiveColor,
  }) {
    if (Platform.isIOS) {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(message),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(cancelText),
            ),
            CupertinoDialogAction(
              isDestructiveAction: isDestructive,
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(confirmText),
            ),
          ],
        ),
      );
    }
    
    // Material Dialog for Android
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B35).withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14, height: 1.5),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              side: const BorderSide(color: Colors.white24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(cancelText, style: const TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestructive 
                  ? (destructiveColor ?? Colors.redAccent) 
                  : const Color(0xFF8B5CF6),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              confirmText, 
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Platform-aware slider
  /// Returns CupertinoSlider on iOS, Slider on Android
  static Widget adaptiveSlider({
    required double value,
    required double min,
    required double max,
    int? divisions,
    Color? activeColor,
    required ValueChanged<double> onChanged,
    String? label,
  }) {
    if (Platform.isIOS) {
      return CupertinoSlider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        activeColor: activeColor,
        onChanged: onChanged,
      );
    }
    return Slider(
      value: value,
      min: min,
      max: max,
      divisions: divisions,
      activeColor: activeColor,
      inactiveColor: Colors.white.withOpacity(0.1),
      label: label,
      onChanged: onChanged,
    );
  }
}
