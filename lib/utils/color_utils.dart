import 'package:flutter/material.dart';

/// A utility class for color operations
class ColorUtils {
  /// Converts a Color with opacity to a Color with equivalent alpha value
  /// This is to replace deprecated withOpacity method
  static Color withOpacityValue(Color color, double opacity) {
    // Convert opacity (0.0-1.0) to alpha (0-255)
    int alpha = (opacity * 255).round();
    return color.withAlpha(alpha);
  }
}

/// Extension method on Color to provide a safe replacement for withOpacity
extension ColorExtension on Color {
  /// Replacement for deprecated withOpacity method
  Color withOpacityValue(double opacity) {
    return ColorUtils.withOpacityValue(this, opacity);
  }
}
