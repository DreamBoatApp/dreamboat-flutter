import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class FastSlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  FastSlidePageRoute({required this.child}) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionDuration: const Duration(milliseconds: 150), // Ultra snappy
    reverseTransitionDuration: const Duration(milliseconds: 150),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var slideAnimation = Tween<Offset>(
        begin: const Offset(0.15, 0.0), // Subtle slide from right
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn, // Smooth and quick
      ));

      var fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ));

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      );
    },
  );

  // Enable iOS swipe-from-left-edge gesture for back navigation
  @override
  bool get popGestureEnabled => Platform.isIOS;
}
