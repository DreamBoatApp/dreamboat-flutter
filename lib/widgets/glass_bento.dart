import 'package:flutter/material.dart';
import 'package:dream_boat_mobile/widgets/glass_card.dart';

class GlassBento extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Decoration? decorationOverride;

  const GlassBento({
    super.key,
    required this.child,
    this.onTap,
    this.height,
    this.width,
    this.padding,
    this.decorationOverride,
  });

  @override
  Widget build(BuildContext context) {
    // Build the glass card content without margin (margin will be handled externally)
    final Widget glassContent = GlassCard(
      padding: padding ?? const EdgeInsets.all(20),
      margin: EdgeInsets.zero, // Remove margin to fix ripple alignment
      child: child,
    );
    
    Widget result;
    if (onTap != null) {
      result = Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24), // Match GlassCard radius
          splashColor: Colors.white.withOpacity(0.12),
          highlightColor: Colors.white.withOpacity(0.06),
          child: glassContent,
        ),
      );
    } else {
      result = glassContent;
    }
    
    // Apply sizing and margin externally
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.only(bottom: 16),
      child: result,
    );
  }
}

class BentoItem extends StatelessWidget {
  final String title;
  final Widget? titleWidget; // [NEW] Custom title support
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback onTap;
  final bool isSpecial;
  final String? subtitle;
  final double height;
  final Widget? content;
  final Widget? background;

  const BentoItem({
    super.key,
    required this.title,
    this.titleWidget,
    this.icon,
    required this.onTap,
    this.iconColor,
    this.isSpecial = false,
    this.subtitle,
    this.height = 160,
    this.content,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: GlassBento(
        onTap: onTap,
        height: height,
        padding: EdgeInsets.zero, // Reset padding for background to fill
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background Visual
            if (background != null)
              background!,
  
            // 2. Content Overlay
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16), // Reduced horizontal padding for more text space
              child: Column(
                children: [
                  // Title at the top-center
                  if (titleWidget != null)
                    titleWidget!
                  else
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        softWrap: false,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14, // Reduced base size
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black26, blurRadius: 4)]
                        ),
                      ),
                    ),
                  
                  if (subtitle != null) ...[
                     const SizedBox(height: 2),
                     Text(subtitle!, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10, letterSpacing: 1.0, shadows: const [Shadow(color: Colors.black26, blurRadius: 4)])),
                  ] else
                     const SizedBox(height: 12),
  
                  if (content == null) const Spacer(),
                  
                  // Content or Icon
                  if (content != null) ...[
                     const SizedBox(height: 12),
                     Expanded(child: content!),
                  ] else if (icon != null) ...[
                     Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (iconColor ?? Colors.white).withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: (iconColor ?? Colors.white).withOpacity(0.2)),
                      ),
                      child: Icon(icon, color: iconColor ?? Colors.white, size: 24),
                    ),
                    const Spacer(),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
