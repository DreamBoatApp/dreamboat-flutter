import 'package:flutter/material.dart';

class AppTheme {
  // Background Colors
  static const Color bgStart = Color(0xFF0F0F23); // Deep Void (Purple Tint)
  static const Color bgMid = Color(0xFF1E1B4B);   // Midnight Indigo
  static const Color bgEnd = Color(0xFF312E81);   // Deep Indigo

  // Nebula Accents
  static const Color nebulaCyan = Color(0xFF06B6D4);
  static const Color nebulaMagenta = Color(0xFFDB2777);
  static const Color goldDust = Color(0xFFFBBF24);

  // Brand Colors
  static const Color primary = Color(0xFFA78BFA);
  static const Color primaryGlow = Color(0x4DA78BFA); // 0.3 opacity
  static const Color secondary = Color(0xFF6366F1);
  
  // Text Colors
  static const Color textMain = Color(0xFFF1F5F9);
  static const Color textMuted = Color(0xFF94A3B8);
  
  // Surface Colors
  static const Color cardBg = Color(0x990F0F23); // 0.6 opacity
  static const Color glassBorder = Color(0x14FFFFFF); // 0.08 opacity

  // ============================================
  // MD3 Spacing Scale
  // ============================================
  static const double spacingXS = 4;   // Tight elements
  static const double spacingSM = 8;   // Small gaps
  static const double spacingMD = 16;  // Default spacing
  static const double spacingLG = 24;  // Section spacing
  static const double spacingXL = 32;  // Large sections

  // ============================================
  // MD3 Type Scale (sp values)
  // ============================================
  static const double fontSizeDisplay = 32;   // Splash, hero text
  static const double fontSizeTitle = 22;     // Dialog titles, card headers
  static const double fontSizeHeadline = 18;  // Section headers
  static const double fontSizeBody = 16;      // Main content
  static const double fontSizeLabel = 14;     // Buttons, form labels
  static const double fontSizeCaption = 12;   // Secondary info, hints

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        background: bgStart,
      ),
      fontFamily: 'Nunito',
      textTheme: const TextTheme(
        // Display - Large hero text (splash screen)
        displayLarge: TextStyle(
          color: textMain,
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.bold,
          fontSize: fontSizeDisplay,
        ),
        // Title - Dialog headers, card titles
        titleLarge: TextStyle(
          color: textMain,
          fontSize: fontSizeTitle,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: textMain,
          fontSize: fontSizeHeadline,
          fontWeight: FontWeight.bold,
        ),
        // Body - Main readable content
        bodyLarge: TextStyle(
          color: textMain,
          fontSize: fontSizeBody,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: textMuted,
          fontSize: fontSizeLabel,
          height: 1.5,
        ),
        // Label - Buttons, interactive elements
        labelLarge: TextStyle(
          color: textMain,
          fontSize: fontSizeLabel,
          fontWeight: FontWeight.w600,
        ),
        // Caption - Secondary info, hints
        bodySmall: TextStyle(
          color: textMuted,
          fontSize: fontSizeCaption,
        ),
      ),
      useMaterial3: true,
    );
  }
}

