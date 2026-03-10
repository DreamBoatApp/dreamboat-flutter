import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream_boat_mobile/widgets/platform_widgets.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';

class DreamImageWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const DreamImageWidget({
    super.key,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 1.0, // Square image (DALL-E 1024x1024)
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.white.withOpacity(0.05),
                child: Center(
                  child: PlatformWidgets.activityIndicator(
                    color: const Color(0xFF3EE6C4),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.white.withOpacity(0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.broken_image_rounded, 
                      color: Colors.white24,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.imageLoadError,
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
