import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dream_boat_mobile/theme/app_theme.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// A shareable card widget that displays dream interpretation text.
/// 
/// This card is designed to be captured as an image for sharing.
/// It only contains the interpretation text and a small watermark.
/// No personal data (dream text, date, time, username) is included.
class DreamShareCard extends StatelessWidget {
  final String interpretation;
  final String watermark;
  final String header;
  
  /// Card dimensions (calculated for 1080px width at 2x pixel ratio)
  static const double cardSize = 540.0; 

  const DreamShareCard({
    super.key,
    required this.interpretation,
    required this.watermark,
    required this.header,
  });

  /// Calculate font size based on text length for optimal fitting
  double _calculateFontSize() {
    final length = interpretation.length;
    if (length < 80) return 26.0;
    if (length < 120) return 24.0;
    if (length < 180) return 22.0;
    if (length < 250) return 20.0;
    if (length < 350) return 18.0;
    if (length < 450) return 16.0;
    return 14.0;
  }

  /// Splits text into first sentence (bold) and the rest (regular)
  List<TextSpan> _buildTextSpans(String text) {
    if (text.isEmpty) return [];

    // Simple heuristic: split by first sentence ending punctuation
    final regex = RegExp(r'(?<=[.!?])\s+');
    final parts = text.split(regex);
    
    if (parts.isEmpty) return [TextSpan(text: text)];

    final firstSentence = parts.first;
    final rest = parts.length > 1 ? text.substring(firstSentence.length) : '';

    return [
      TextSpan(
        text: firstSentence,
        style: const TextStyle(fontWeight: FontWeight.w600), // Medium-Bold emphasis
      ),
      if (rest.isNotEmpty)
        TextSpan(
          text: rest,
          style: const TextStyle(fontWeight: FontWeight.w300), // Light/Regular for contrast
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = _calculateFontSize();
    
    return Container(
      width: cardSize,
      height: cardSize,
      decoration: BoxDecoration(
        // Base dark background
        color: const Color(0xFF0A0A1A),
        borderRadius: BorderRadius.circular(40), // Softer corners
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          children: [
            // 1. Base Linear Gradient (Deep Void -> Indigo)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F0F23), // Deep void
                    Color(0xFF16163F), // Dark navy
                    Color(0xFF2E2E5E), // Lighter indigo bottom-right
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
              ),
            ),
            
            // 2. Aura/Vignette Effect (Radial)
            // Center is lighter/misty, edges darker
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    const Color(0xFF4C1D95).withOpacity(0.15), // Center glow (Purple)
                    Colors.transparent,
                    Colors.black.withOpacity(0.4), // Vignette edges
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),

            // 3. Star Field (Enhanced depth)
            CustomPaint(
              size: const Size(cardSize, cardSize),
              painter: _StarFieldPainter(),
            ),
            
            // 4. Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              child: Column(
                children: [
                  // === HEADER SECTION ===
                  Text(
                    header.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                      fontFamily: 'Nunito',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Top Divider Line
                  Container(
                    width: cardSize * 0.25,
                    height: 1,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // === MAIN CONTENT (Full text, no truncation) ===
                  Expanded(
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: _buildTextSpans(interpretation),
                          style: TextStyle(
                             color: Colors.white,
                             fontSize: fontSize,
                             height: 1.5,
                             letterSpacing: 0.2,
                             fontFamily: 'Nunito',
                             decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // === FOOTER SECTION ===
                  // Bottom Divider Line
                  Container(
                    width: cardSize * 0.25,
                    height: 1,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Watermark with boat icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'DREAMBOAT APP ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                          fontFamily: 'Nunito',
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Icon(
                        LucideIcons.sailboat,
                        size: 11,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      Text(
                        ' ${_getWatermarkSuffix(watermark)}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                          fontFamily: 'Nunito',
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 5. Inner Glow / Border (Top-Left 3D effect)
            CustomPaint(
               size: const Size(cardSize, cardSize),
               painter: _InnerGlowPainter(),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Extract the localized suffix from watermark (e.g., "ile yorumlandı" from "DreamBoat App ile yorumlandı")
  String _getWatermarkSuffix(String watermark) {
    // Remove "DreamBoat App" or similar prefix to get just the action phrase
    final lowerWatermark = watermark.toLowerCase();
    if (lowerWatermark.contains('dreamboat app')) {
      final parts = watermark.split(RegExp(r'DreamBoat App\s*', caseSensitive: false));
      return parts.length > 1 ? parts[1].toUpperCase() : '';
    }
    if (lowerWatermark.contains('dreamboat')) {
      final parts = watermark.split(RegExp(r'DreamBoat\s*', caseSensitive: false));
      return parts.length > 1 ? parts[1].toUpperCase() : '';
    }
    return watermark.toUpperCase();
  }
}

/// Paints the inner glow border effect (Top & Left only)
class _InnerGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(40));
    
    // Gradient stroke for Top-Left
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
           Colors.white24, // Brightest at top-left
           Colors.transparent, // Fades out
        ],
        stops: [0.0, 0.4], 
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// Paints a start field with depth
class _StarFieldPainter extends CustomPainter {
  final Random _random = Random(42); // Fixed seed for consistent look

  @override
  void paint(Canvas canvas, Size size) {
    
    for (int i = 0; i < 40; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      
      // Varied size and opacity for depth
      final double radius = _random.nextDouble() * 1.2 + 0.5;
      final double opacity = _random.nextDouble() * 0.4 + 0.1;
      
      final starPaint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      // Glow effect for some stars
      if (_random.nextDouble() > 0.8) {
         canvas.drawCircle(
           Offset(x, y), 
           radius * 2.5, 
           Paint()..color = Colors.white.withOpacity(0.05)
         );
      }
      
      canvas.drawCircle(Offset(x, y), radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
