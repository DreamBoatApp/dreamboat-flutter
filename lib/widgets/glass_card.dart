import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dream_boat_mobile/theme/app_styles.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? accentColor; // Optional mood-based accent

  const GlassCard({
    super.key, 
    required this.child, 
    this.padding, 
    this.margin,
    this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    const double radius = 24; // Increased from 20 for softer look
    
    Widget cardContent;
    
    if (onTap != null) {
      cardContent = Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          splashColor: Colors.white.withOpacity(0.12),
          highlightColor: Colors.white.withOpacity(0.06),
          child: Ink(
            decoration: BoxDecoration(
              // Solid dark background + slight white overlay for glass effect
              color: const Color(0xFF0F0F23).withOpacity(0.85),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            ),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(20),
              child: child,
            ),
          ),
        ),
      );
    } else {
      cardContent = Container(
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // Solid dark background + slight white overlay for glass effect
          color: const Color(0xFF0F0F23).withOpacity(0.85),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: child,
      );
    }

    // Wrap with accent bar if accentColor is provided
    Widget content;
    if (accentColor != null) {
      content = Stack(
        children: [
          cardContent,
          // Accent bar on left edge
          Positioned(
            left: 0,
            top: 8,
            bottom: 8,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: accentColor!.withOpacity(0.4),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      content = cardContent;
    }

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: content,
      ),
    );
  }
}
