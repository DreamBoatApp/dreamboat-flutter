import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dream_boat_mobile/theme/app_theme.dart';

class AppStyles {
  static BoxDecoration glassDecoration = BoxDecoration(
    color: AppTheme.cardBg,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppTheme.glassBorder),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        spreadRadius: 0,
      )
    ],
  );

  static BoxDecoration buttonDecoration = BoxDecoration(
    color: Color(0x800F0F23), // 0.5 opacity
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppTheme.glassBorder),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 24,
        offset: Offset(0, 4),
      )
    ],
  );
}
