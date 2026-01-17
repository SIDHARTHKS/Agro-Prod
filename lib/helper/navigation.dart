import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'enum.dart';
import 'app_message.dart';

/// Navigate to a screen with optional arguments
void navigateTo(
  String routeName, {
  dynamic arguments,
  Transition transition = Transition.fadeIn,
  bool clearStack = false,
}) {
  appLog('Screen: $routeName arguments: $arguments', logging: Logging.info);

  if (clearStack) {
    Get.offAllNamed(routeName, arguments: arguments);
  } else {
    Get.toNamed(routeName, arguments: arguments);
  }
}

/// Navigate back to the previous screen
void goBack() {
  Get.back();
}

/// Navigate to a screen and remove all previous screens from the stack
void navigateToAndRemoveAll(
  String routeName, {
  dynamic arguments,
  Transition transition = Transition.fadeIn,
}) {
  appLog('Screen: $routeName arguments: $arguments', logging: Logging.info);
  Get.offAllNamed(routeName, arguments: arguments);
}

/// Navigate to a screen and remove the previous screen from the stack
void navigateToAndRemove(
  String routeName, {
  dynamic arguments,
  Transition transition = Transition.fadeIn,
}) {
  appLog('Screen: $routeName arguments: $arguments', logging: Logging.info);
  Get.offNamed(routeName, arguments: arguments);
}

void animateFromSplashToRoute(BuildContext context, String routeName) {
  final match = Get.routeTree.matchRoute(routeName);
  final route = match.route;

  if (route == null) {
    throw Exception('Route not found: $routeName');
  }

  // Run binding manually (this is what Get.toNamed normally does)
  route.binding?.dependencies();

  final pageBuilder = route.page;

  Navigator.of(context).pushAndRemoveUntil(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (context, animation, secondaryAnimation) {
        return pageBuilder();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final splashAnim = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        final loginSlide = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        return Stack(
          children: [
            // Splash shrinking + moving up
            AnimatedBuilder(
              animation: splashAnim,
              builder: (context, _) {
                final t = 1 - splashAnim.value;
                final scaleX = 1 - (0.4 * t);
                final translateY = -200 * t;

                return Transform.translate(
                  offset: Offset(0, translateY),
                  child: Transform.scale(
                    scaleX: scaleX,
                    scaleY: 1,
                    child: context.widget,
                  ),
                );
              },
            ),

            // Target page sliding from bottom
            SlideTransition(
              position: loginSlide,
              child: child,
            ),
          ],
        );
      },
    ),
    (route) => false,
  );
}
