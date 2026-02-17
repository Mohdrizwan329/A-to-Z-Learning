import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Kids-friendly theme configuration for the entire app
/// Figma-style Design System with Glassmorphism
class AppTheme {
  // ============== DESIGN SYSTEM COLORS ==============

  // Primary: Soft Blue
  static const Color primaryColor = Color(0xFF4AA3F0);
  static const Color primaryLight = Color(0xFF7BBFF5);
  static const Color primaryDark = Color(0xFF2B8AD9);

  // Secondary: Warm Yellow
  static const Color secondaryColor = Color(0xFFFFD966);
  static const Color secondaryLight = Color(0xFFFFE699);
  static const Color secondaryDark = Color(0xFFE6C04D);

  // Accent: Green
  static const Color accentColor = Color(0xFF6FCF97);
  static const Color accentLight = Color(0xFF9FDFB8);
  static const Color accentDark = Color(0xFF4FB87A);

  // Semantic Colors
  static const Color successColor = Color(0xFF6FCF97);
  static const Color errorColor = Color(0xFFFF6B6B);
  static const Color warningColor = Color(0xFFFFD966);
  static const Color infoColor = Color(0xFF4AA3F0);

  // Background: Off-White
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color cardBackground = Colors.white;
  static const Color surfaceColor = Color(0xFFF5F7FA);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFB2BEC3);
  static const Color textWhite = Colors.white;

  // ============== DESIGN TOKENS ==============

  // Border Radius (16-24px as per spec)
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 20.0;
  static const double radiusXLarge = 24.0;
  static const double radiusRound = 100.0;

  // Minimum Touch Area (48px)
  static const double minTouchTarget = 48.0;
  static const double buttonHeight = 56.0;
  static const double iconButtonSize = 48.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // ============== GRADIENTS ==============

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
    stops: [0.0, 0.3, 0.7, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFFFD966), Color(0xFFFFB347)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF6FCF97), Color(0xFF4ECDC4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient screenGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
    stops: [0.0, 0.3, 0.7, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient funGradient = LinearGradient(
    colors: [Color(0xFF6FCF97), Color(0xFF4ECDC4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFFD966), Color(0xFFFF6B6B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient rainbowGradient = LinearGradient(
    colors: [
      Color(0xFFFF6B6B),
      Color(0xFFFFD966),
      Color(0xFF6FCF97),
      Color(0xFF4AA3F0),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Card Gradients (Kid-friendly soft colors)
  static const List<LinearGradient> cardGradients = [
    LinearGradient(colors: [Color(0xFF4AA3F0), Color(0xFF667EEA)]), // Blue
    LinearGradient(colors: [Color(0xFFFFD966), Color(0xFFFFB347)]), // Yellow
    LinearGradient(colors: [Color(0xFF6FCF97), Color(0xFF4ECDC4)]), // Green
    LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)]), // Red
    LinearGradient(colors: [Color(0xFFA29BFE), Color(0xFF6C5CE7)]), // Purple
    LinearGradient(colors: [Color(0xFFFFB8B8), Color(0xFFFF9FF3)]), // Pink
    LinearGradient(colors: [Color(0xFF81ECEC), Color(0xFF00CEC9)]), // Teal
    LinearGradient(colors: [Color(0xFFFDCB6E), Color(0xFFE17055)]), // Orange
    LinearGradient(colors: [Color(0xFF74B9FF), Color(0xFF0984E3)]), // Sky
    LinearGradient(colors: [Color(0xFF55EFC4), Color(0xFF00B894)]), // Mint
    LinearGradient(colors: [Color(0xFFDFE6E9), Color(0xFFB2BEC3)]), // Grey
    LinearGradient(colors: [Color(0xFFFAB1A0), Color(0xFFE74C3C)]), // Coral
  ];

  // ============== TEXT STYLES (Google Fonts) ==============

  // Heading Font: Poppins (fallback to Baloo)
  static TextStyle get headingLarge => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: 0.5,
  );

  static TextStyle get headingMedium => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: 0.3,
  );

  static TextStyle get headingSmall => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  // Body Font: Nunito
  static TextStyle get bodyLarge => GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );

  static TextStyle get bodySmall => GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );

  // Button Text
  static TextStyle get buttonText => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textWhite,
    letterSpacing: 0.5,
  );

  // Special: Fun/Playful Font for Kids
  static TextStyle get funText => GoogleFonts.comicNeue(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  // Large Display Text (Numbers, Letters)
  static TextStyle get displayLarge => GoogleFonts.poppins(
    fontSize: 64,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static TextStyle get displayMedium => GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  // ============== SOFT SHADOWS ==============

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 12),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> colorShadow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.3),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  // ============== GLASSMORPHISM DECORATIONS ==============

  static BoxDecoration get glassDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.2),
    borderRadius: BorderRadius.circular(radiusLarge),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.3),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  );

  static BoxDecoration glassCard({
    double radius = 20,
    Color? backgroundColor,
  }) => BoxDecoration(
    color: (backgroundColor ?? Colors.white).withValues(alpha: 0.85),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.5),
      width: 1,
    ),
    boxShadow: softShadow,
  );

  static BoxDecoration get screenBackground => const BoxDecoration(
    gradient: screenGradient,
  );

  static BoxDecoration cardDecoration({
    Color? color,
    double radius = 20,
  }) => BoxDecoration(
    color: color ?? cardBackground,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: softShadow,
  );

  static BoxDecoration gradientCardDecoration({
    required LinearGradient gradient,
    double radius = 20,
  }) => BoxDecoration(
    gradient: gradient,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: colorShadow(gradient.colors.first),
  );

  // ============== BUTTON STYLES ==============

  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: textWhite,
    minimumSize: const Size(double.infinity, buttonHeight),
    padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
    ),
    elevation: 0,
    shadowColor: Colors.transparent,
  );

  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    foregroundColor: textPrimary,
    minimumSize: const Size(double.infinity, buttonHeight),
    padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
    ),
    elevation: 0,
  );

  static ButtonStyle get accentButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: accentColor,
    foregroundColor: textWhite,
    minimumSize: const Size(double.infinity, buttonHeight),
    padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
    ),
    elevation: 0,
  );

  static ButtonStyle get outlineButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    minimumSize: const Size(double.infinity, buttonHeight),
    padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
    ),
    side: const BorderSide(color: primaryColor, width: 2),
  );

  static ButtonStyle get ghostButtonStyle => TextButton.styleFrom(
    foregroundColor: primaryColor,
    minimumSize: const Size(minTouchTarget, minTouchTarget),
    padding: const EdgeInsets.symmetric(horizontal: spacingM, vertical: spacingS),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
    ),
  );

  // ============== THEME DATA ==============

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: surfaceColor,
      error: errorColor,
    ),
    fontFamily: GoogleFonts.nunito().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: headingMedium.copyWith(color: textWhite),
      iconTheme: const IconThemeData(color: textWhite, size: 24),
    ),
    cardTheme: CardThemeData(
      color: cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
      margin: const EdgeInsets.all(spacingS),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
    outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonStyle),
    textButtonTheme: TextButtonThemeData(style: ghostButtonStyle),
    textTheme: TextTheme(
      headlineLarge: headingLarge,
      headlineMedium: headingMedium,
      headlineSmall: headingSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: buttonText,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingL,
        vertical: spacingM,
      ),
      hintStyle: bodyMedium.copyWith(color: textLight),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: textWhite,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimary,
      contentTextStyle: bodyMedium.copyWith(color: textWhite),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardBackground,
      selectedItemColor: primaryColor,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: textWhite,
      unselectedLabelColor: textLight,
      indicatorColor: textWhite,
      labelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceColor,
      selectedColor: primaryColor.withValues(alpha: 0.2),
      labelStyle: bodyMedium,
      padding: const EdgeInsets.symmetric(
        horizontal: spacingM,
        vertical: spacingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusRound),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusXLarge),
      ),
      titleTextStyle: headingSmall,
      contentTextStyle: bodyMedium,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: const Color(0xFF2D2D44),
      error: errorColor,
    ),
    fontFamily: GoogleFonts.nunito().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: headingMedium.copyWith(color: textWhite),
      iconTheme: const IconThemeData(color: textWhite),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF2D2D44),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: headingLarge.copyWith(color: textWhite),
      headlineMedium: headingMedium.copyWith(color: textWhite),
      headlineSmall: headingSmall.copyWith(color: textWhite),
      bodyLarge: bodyLarge.copyWith(color: textWhite),
      bodyMedium: bodyMedium.copyWith(color: textLight),
      bodySmall: bodySmall.copyWith(color: textLight),
      labelLarge: buttonText,
    ),
  );

  // ============== HELPER METHODS ==============

  /// Get a random card gradient
  static LinearGradient getCardGradient(int index) {
    return cardGradients[index % cardGradients.length];
  }

  /// Wrap child with screen gradient background
  static Widget screenWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: screenBackground,
      child: child,
    );
  }

  /// Glassmorphism container
  static Widget glassContainer({
    required Widget child,
    double radius = 20,
    EdgeInsets padding = const EdgeInsets.all(16),
    EdgeInsets margin = EdgeInsets.zero,
  }) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding,
            decoration: glassDecoration,
            child: child,
          ),
        ),
      ),
    );
  }

  /// Big tap target button
  static Widget bigTapButton({
    required Widget child,
    required VoidCallback onTap,
    Color? backgroundColor,
    LinearGradient? gradient,
    double size = 80,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: gradient == null ? (backgroundColor ?? primaryColor) : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(radiusLarge),
          boxShadow: colorShadow(
            gradient?.colors.first ?? backgroundColor ?? primaryColor,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }

  /// Build gradient AppBar
  static PreferredSizeWidget buildAppBar({
    required String title,
    String? emoji,
    IconData? icon,
    List<Widget>? actions,
    bool showBackButton = true,
    VoidCallback? onBack,
    LinearGradient? gradient,
  }) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? GestureDetector(
              onTap: onBack,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(radiusMedium),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            )
          : null,
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: gradient ?? const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)])),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emoji != null) ...[
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: spacingS),
          ] else if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: spacingS),
          ],
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  /// Category card with gradient
  static Widget categoryCard({
    required String title,
    required String emoji,
    required VoidCallback onTap,
    required int index,
    String? subtitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: gradientCardDecoration(
          gradient: getCardGradient(index),
          radius: radiusLarge,
        ),
        child: Padding(
          padding: const EdgeInsets.all(spacingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: spacingS),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textWhite,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    color: textWhite.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
