import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Styles de texte du design system (police Inter).
///
/// Taille / graisse / interligne identiques aux styles Figma « CityAlert/... ».
/// On passe la couleur en paramètre : `AppText.body(context.colors.text)`.
abstract final class AppText {
  static TextStyle _inter(double size, FontWeight weight, double lineHeight, Color color) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      height: lineHeight / size,
      color: color,
    );
  }

  /// Display : Inter Bold 28 / 36.
  static TextStyle display(Color c) => _inter(28, FontWeight.w700, 36, c);

  /// Title : Inter SemiBold 20 / 28.
  static TextStyle title(Color c) => _inter(20, FontWeight.w600, 28, c);

  /// Card title : Inter SemiBold 16 / 24.
  static TextStyle cardTitle(Color c) => _inter(16, FontWeight.w600, 24, c);

  /// Body : Inter Regular 14 / 20.
  static TextStyle body(Color c) => _inter(14, FontWeight.w400, 20, c);

  /// Body strong : Inter SemiBold 14 / 20.
  static TextStyle bodyStrong(Color c) => _inter(14, FontWeight.w600, 20, c);

  /// Caption : Inter Regular 12 / 16.
  static TextStyle caption(Color c) => _inter(12, FontWeight.w400, 16, c);

  /// Caption strong : Inter SemiBold 12 / 16.
  static TextStyle captionStrong(Color c) => _inter(12, FontWeight.w600, 16, c);
}
