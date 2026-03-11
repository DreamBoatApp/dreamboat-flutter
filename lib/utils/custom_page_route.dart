import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class FastSlidePageRoute<T> extends PageRoute<T> with CupertinoRouteTransitionMixin<T> {
  final Widget child;

  FastSlidePageRoute({required this.child, RouteSettings? settings}) : super(settings: settings);

  @override
  Widget buildContent(BuildContext context) => child;

  @override
  String? get title => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300); // Slightly slower for swipe gesture stability

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if (Platform.isIOS) {
       // On iOS, use the Mixin's default transition (Slide from right) which supports the gesture perfectly
       // We can override standard IOS animation if we want, but using default is safest for gesture.
       // However, user wanted "Fast".
       // Let's use our custom animation BUT wrapped in the gesture support provided by Mixin.
       // Wait, Mixin uses buildPageTransitions.
       return super.buildTransitions(context, animation, secondaryAnimation, child);
    }

    // Custom Animation for Android/Others
    var slideAnimation = Tween<Offset>(
      begin: const Offset(0.15, 0.0), 
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.fastOutSlowIn, 
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
  }
}
