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
    return Container(
      color: const Color(0xFF0F0F23), // Dark background matching app theme
      width: 1024, // High res target
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. The Dream Image (Square)
          AspectRatio(
            aspectRatio: 1.0, 
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: const Color(0xFF1a1a2e)),
            ),
          ),
          
          // 2. Watermark Footer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            decoration: const BoxDecoration(
              color: Color(0xFF2A2640), // Premium Soft Purple
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo (White)
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  child: Image.asset(
                    'assets/images/db_logo_icon.png',
                    height: 32,
                    width: 32,
                  ),
                ),
                const SizedBox(width: 12),
                // Text
                Text(
                  watermarkText, // Now localized as "DreamBoat app ile Görselleştirildi" from Service
                  style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
