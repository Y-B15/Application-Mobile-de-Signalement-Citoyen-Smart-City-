import 'package:flutter/material.dart';

/// Rayons du design system : 8 (boutons, badges, onglets), 12 (cartes), 16 (grandes cartes).
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
}

/// Ombres du design system.
abstract final class AppShadows {
  /// « CityAlert/Elevation 1 » : ombre portée noire à 8 %, décalage Y 1, flou 3.
  static const List<BoxShadow> elevation1 = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
  ];
}
