import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class DreamImageShareCard extends StatelessWidget {
  final String imageUrl;
  final String watermarkText;

  const DreamImageShareCard({
    super.key,
    required this.imageUrl,
    required this.watermarkText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1024,
      height: 1024,
      child: Stack(
        children: [
          // Full-bleed dream image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: const Color(0xFF1a1a2e)),
            ),
          ),

          // Painter-style signature — bottom-right corner
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.85),
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      'assets/images/db_logo_icon.png',
                      height: 18,
                      width: 18,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    watermarkText,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
