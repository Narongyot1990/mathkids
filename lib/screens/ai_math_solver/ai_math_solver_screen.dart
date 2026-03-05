import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'camera_capture_screen.dart';
import 'camera_capture_screen_web.dart';

/// Platform-aware AI Math Solver entry point
/// Automatically routes to correct implementation based on platform
class AIMathSolverScreen extends StatelessWidget {
  const AIMathSolverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use web version for web platform
    if (kIsWeb) {
      return const CameraCaptureScreenWeb();
    }

    // Use mobile version for iOS/Android
    return const CameraCaptureScreen();
  }
}
