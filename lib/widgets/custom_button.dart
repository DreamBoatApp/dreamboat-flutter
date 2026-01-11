import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dream_boat_mobile/theme/app_styles.dart';
import 'package:dream_boat_mobile/theme/app_theme.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Gradient? gradient;
  final Widget? trailing;

  final String? loadingText;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.loadingText,
    this.icon,
    this.gradient,
    this.trailing,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.isLoading;
    
    return Opacity(
      opacity: isDisabled ? 0.6 : 1.0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 14),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48), // MD3 minimum touch target
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTapDown: isDisabled ? null : (_) => _controller.forward(),
                    onTapUp: isDisabled ? null : (_) => _controller.reverse(),
                    onTapCancel: isDisabled ? null : () => _controller.reverse(),
                    onTap: isDisabled ? null : widget.onPressed,
                    borderRadius: BorderRadius.circular(20),
                    splashColor: Colors.white.withOpacity(0.15),
                    highlightColor: Colors.white.withOpacity(0.08),
                    child: Ink(
                      decoration: AppStyles.buttonDecoration.copyWith(
                        // Use provided gradient or default to partial primary
                         gradient: widget.gradient ?? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0x1AA78BFA), // Primary color with low opacity
                            Colors.transparent,
                          ]
                         )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                        child: Center(
                          child: widget.isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    ),
                                    if (widget.loadingText != null) ...[
                                       const SizedBox(width: 12),
                                       Text(
                                         widget.loadingText!, 
                                         style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)
                                       )
                                    ]
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                     if (widget.icon != null) ...[
                                       Icon(widget.icon, color: Colors.white, size: 24),
                                       const SizedBox(width: 16),
                                     ],
                                    Flexible(
                                      child: Text(
                                        widget.text,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (widget.trailing != null) ...[
                                       const SizedBox(width: 12),
                                       widget.trailing!,
                                    ]
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
