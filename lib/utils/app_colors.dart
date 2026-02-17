import 'package:flutter/material.dart';

/// Centralized color constants for the entire app
/// All gradient colors and theme colors are defined here for consistency
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // ============ PRIMARY APP COLORS ============
  static const Color primary = Color(0xFFFF6B6B);
  static const Color primaryLight = Color(0xFFFF8E8E);
  static const Color secondary = Color(0xFF667EEA);
  static const Color accent = Color(0xFFFFD700);

  // ============ APPBAR GRADIENT ============
  static const List<Color> appBarGradient = [
    Color(0xFFFF6B6B),
    Color(0xFFFF8E53),
    Color(0xFFFFAA5A),
  ];

  // ============ BODY/BACKGROUND GRADIENT ============
  static const List<Color> bodyGradient = [
    Color(0xFF667EEA),
    Color(0xFF764BA2),
    Color(0xFFF093FB),
    Color(0xFFF5576C),
  ];

  // ============ SELECTED/GOLDEN GRADIENT ============
  static const List<Color> selectedGradient = [
    Color(0xFFFFD700),
    Color(0xFFFFA500),
  ];

  // ============ CARD GRADIENTS (for grid items) ============
  static const List<List<Color>> cardGradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E8E)], // Red
    [Color(0xFFFFAA5A), Color(0xFFFFCB80)], // Orange
    [Color(0xFFFFE66D), Color(0xFFFFF59D)], // Yellow
    [Color(0xFF4ECDC4), Color(0xFF7EDDD6)], // Teal
    [Color(0xFF45B7D1), Color(0xFF74C9DB)], // Blue
    [Color(0xFFA78BFA), Color(0xFFC4B5FD)], // Purple
    [Color(0xFFFF6EB4), Color(0xFFFF9ECE)], // Pink
    [Color(0xFF56D97F), Color(0xFF81E89E)], // Green
    [Color(0xFF5C6BC0), Color(0xFF8E99D4)], // Indigo
    [Color(0xFFEC407A), Color(0xFFF06292)], // Dark Pink
  ];

  // ============ CATEGORY GRADIENTS ============
  static const Map<String, List<Color>> categoryGradients = {
    'alphabets': [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    'numbers': [Color(0xFF4ECDC4), Color(0xFF7EDDD6)],
    'tables': [Color(0xFFA78BFA), Color(0xFFC4B5FD)],
    'hindi': [Color(0xFFFF9A56), Color(0xFFFFBB80)],
    'learning': [Color(0xFF45B7D1), Color(0xFF74C9DB)],
    'math': [Color(0xFF56D97F), Color(0xFF81E89E)],
    'drawing': [Color(0xFFFF6EB4), Color(0xFFFF9ECE)],
  };

  // ============ HELPER METHODS ============

  /// Get gradient for a specific index (cycles through cardGradients)
  static List<Color> getGradientForIndex(int index) {
    return cardGradients[index % cardGradients.length];
  }

  /// Get gradient for a category or return default
  static List<Color> getGradientForCategory(String category) {
    return categoryGradients[category.toLowerCase()] ?? cardGradients[0];
  }

  /// Create a linear gradient decoration
  static BoxDecoration gradientDecoration({
    List<Color>? colors,
    double borderRadius = 16,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors ?? cardGradients[0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: shadows,
    );
  }

  /// Standard shadow for cards
  static List<BoxShadow> cardShadow(Color baseColor, {bool isSelected = false}) {
    return [
      BoxShadow(
        color: baseColor.withValues(alpha: 0.4),
        blurRadius: isSelected ? 15 : 8,
        offset: const Offset(0, 4),
        spreadRadius: isSelected ? 2 : 0,
      ),
    ];
  }
}
