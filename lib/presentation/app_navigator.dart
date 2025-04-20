import 'package:flutter/material.dart';

class AppNavigator {
  static void slidePushRightToLeft(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(1.0, 0.0), // Slide in from right
            end: Offset.zero,
          ).animate(animation);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  static void slidePushReplacementLeftToRight(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(-1.0, 0.0), // Slide in from left
            end: Offset.zero,
          ).animate(animation);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }
}
