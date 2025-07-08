import 'package:flutter/material.dart';

/// A utility class for handling deprecated Flutter APIs
class DeprecationFixes {
  /// Convert withOpacity calls to the recommended approach
  ///
  /// Replace color.withOpacity(value) with this method
  static Color withOpacityValue(Color color, double opacity) {
    // For direct value conversion:
    return color.withAlpha((opacity * 255).round());

    // Alternative using withRGBO:
    // return Color.fromRGBO(
    //   color.red,
    //   color.green,
    //   color.blue,
    //   opacity
    // );
  }

  /// Helper for handling the deprecated BuildContext across async gaps warning
  ///
  /// Usage: await DeprecationFixes.asyncContextOperation(context, () async {
  ///   // Your async operation
  /// });
  static Future<T?> asyncContextOperation<T>(
    BuildContext context,
    Future<T> Function() operation,
  ) async {
    // Store any context-dependent values before the async gap
    final scaffold = ScaffoldMessenger.of(context);

    try {
      final result = await operation();
      return result;
    } catch (e) {
      // Handle exceptions with the pre-captured scaffold
      scaffold.showSnackBar(
        SnackBar(content: Text('Operation failed: $e')),
      );
      return null;
    }
  }

  /// Generate proper color lerp functions that avoid deprecated APIs
  static Color lerpColorSafe(Color a, Color b, double t) {
    return Color.fromARGB(
      lerpInt(a.alpha, b.alpha, t),
      lerpInt(a.red, b.red, t),
      lerpInt(a.green, b.green, t),
      lerpInt(a.blue, b.blue, t),
    );
  }

  /// Integer interpolation helper for the lerpColorSafe method
  static int lerpInt(int a, int b, double t) {
    return (a + (b - a) * t).round().clamp(0, 255);
  }
}

/// Extension for Color to make withOpacity replacement more seamless
extension ColorExtension on Color {
  /// Safe replacement for the deprecated withOpacity method
  Color withOpacitySafe(double opacity) {
    return DeprecationFixes.withOpacityValue(this, opacity);
  }
}
