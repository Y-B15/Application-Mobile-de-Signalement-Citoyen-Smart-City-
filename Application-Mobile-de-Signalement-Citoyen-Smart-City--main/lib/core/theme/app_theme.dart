import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_decor.dart';

/// Thèmes clair et sombre de CityAlert (Material 3).
abstract final class AppTheme {
  static ThemeData light() => _build(CityAlertColors.light, Brightness.light);
  static ThemeData dark() => _build(CityAlertColors.dark, Brightness.dark);

  static ThemeData _build(CityAlertColors c, Brightness brightness) {
    // Thème de base : sert uniquement à récupérer les tailles Material.
    final base = ThemeData(brightness: brightness, useMaterial3: true);

    // Inter partout, dans la couleur de texte du thème.
    final textTheme = GoogleFonts.interTextTheme(base.textTheme)
        .apply(bodyColor: c.text, displayColor: c.text);

    final scheme = ColorScheme.fromSeed(
      seedColor: c.primary,
      brightness: brightness,
    ).copyWith(
      primary: c.primary,
      onPrimary: c.onPrimary,
      surface: c.surface,
      onSurface: c.text,
      error: c.urgent,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      textTheme: textTheme,
      dividerColor: c.divider,
      extensions: <ThemeExtension<dynamic>>[c],
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.text,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: c.background,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }
}
