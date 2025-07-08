import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Green Theme for Agriculture
  static const Color primary = Color(0xFF2D7A46);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryExtraLight = Color(0xFF81C784);
  
  // Secondary Colors - Warm Orange/Yellow
  static const Color accent = Color(0xFFF8B133);
  static const Color accentLight = Color(0xFFFFCC80);
  static const Color accentDark = Color(0xFFFF8F00);
  
  // Neutral Colors
  static const Color background = Color(0xFFF8FFFE);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color surfaceTint = Color(0xFFE8F5E8);
  
  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);
  
  static const Color error = Color(0xFFE53E3E);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorDark = Color(0xFFD32F2F);
  
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);
  
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textLight = Color(0xFF718096);
  static const Color textInverse = Colors.white;
  static const Color textMuted = Color(0xFF9CA3AF);
  
  // Border Colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DB);
  static const Color borderDark = Color(0xFF9CA3AF);
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentLight],
  );
  
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, successLight],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, surfaceTint],
  );
  
  // Special Colors for Agriculture Theme
  static const Color cropGreen = Color(0xFF8BC34A);
  static const Color soilBrown = Color(0xFF8D6E63);
  static const Color skyBlue = Color(0xFF87CEEB);
  static const Color sunYellow = Color(0xFFFDD835);
  static const Color waterBlue = Color(0xFF42A5F5);
  
  // Card Colors
  static const Color cardBackground = Colors.white;
  static const Color cardShadow = Color(0x0F000000);
  
  // Status Colors
  static const Color online = Color(0xFF4CAF50);
  static const Color offline = Color(0xFF9E9E9E);
  static const Color pending = Color(0xFFFF9800);
  static const Color active = Color(0xFF2196F3);
  static const Color inactive = Color(0xFF9E9E9E);
  
  // Feature-specific colors
  static const Color cropDiagnosis = Color(0xFF00BCD4);
  static const Color marketPrice = Color(0xFF4CAF50);
  static const Color subsidies = Color(0xFF2196F3);
  static const Color weather = Color(0xFF03A9F4);
  static const Color community = Color(0xFF9C27B0);
  static const Color news = Color(0xFFFF5722);
  static const Color analytics = Color(0xFF795548);
  static const Color inventory = Color(0xFF607D8B);
  static const Color expenses = Color(0xFFE91E63);
  static const Color income = Color(0xFF4CAF50);
  
  // Premium colors
  static const Color premium = Color(0xFFFFD700);
  static const Color premiumLight = Color(0xFFFFF176);
  static const Color premiumDark = Color(0xFFFFA000);
  
  // Expert colors
  static const Color expertBadge = Color(0xFF6A1B9A);
  static const Color expertBackground = Color(0xFFE1BEE7);
  
  // Notification colors
  static const Color notificationRed = Color(0xFFFF3B30);
  static const Color notificationGreen = Color(0xFF34C759);
  static const Color notificationBlue = Color(0xFF007AFF);
  static const Color notificationYellow = Color(0xFFFFCC00);
}

// Extension for color utilities
extension AppColorsExtension on Color {
  Color get withLightOpacity => withOpacity(0.1);
  Color get withMediumOpacity => withOpacity(0.3);
  Color get withHighOpacity => withOpacity(0.7);
  
  // Generate different shades of the same color
  Color get lighten => Color.fromRGBO(
    (red + (255 - red) * 0.2).round(),
    (green + (255 - green) * 0.2).round(),
    (blue + (255 - blue) * 0.2).round(),
    opacity,
  );
  
  Color get darken => Color.fromRGBO(
    (red * 0.8).round(),
    (green * 0.8).round(),
    (blue * 0.8).round(),
    opacity,
  );
}

// Color palette for different themes
class AppColorPalettes {
  static const Map<String, Color> agriculture = {
    'primary': Color(0xFF2D7A46),
    'secondary': Color(0xFF8BC34A),
    'accent': Color(0xFFF8B133),
    'background': Color(0xFFF8FFFE),
  };
  
  static const Map<String, Color> nature = {
    'primary': Color(0xFF4CAF50),
    'secondary': Color(0xFF8BC34A),
    'accent': Color(0xFFFFEB3B),
    'background': Color(0xFFF1F8E9),
  };
  
  static const Map<String, Color> professional = {
    'primary': Color(0xFF1976D2),
    'secondary': Color(0xFF42A5F5),
    'accent': Color(0xFFFF9800),
    'background': Color(0xFFF5F5F5),
  };
}
