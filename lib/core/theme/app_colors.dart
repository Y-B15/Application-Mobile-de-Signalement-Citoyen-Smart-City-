import 'package:flutter/material.dart';

import '../models/report.dart';

/// Palette CityAlert, clair et sombre.
///
/// Chaque valeur vient d'un style Figma (« CityAlert/Light/... »,
/// « CityAlert/Dark/... », « CityAlert/Primary »). Lecture dans un widget :
/// `context.colors.primary`.
@immutable
class CityAlertColors extends ThemeExtension<CityAlertColors> {
  const CityAlertColors({
    required this.background,
    required this.surface,
    required this.text,
    required this.caption,
    required this.divider,
    required this.line,
    required this.primary,
    required this.onPrimary,
    required this.reported,
    required this.inProgress,
    required this.resolved,
    required this.urgent,
    required this.selectedTint,
    required this.accentTint,
  });

  /// Fond des écrans.
  final Color background;

  /// Fond des cartes et de la barre de navigation.
  final Color surface;

  /// Texte principal.
  final Color text;

  /// Texte secondaire (« caption »).
  final Color caption;

  /// Trait séparateur fin (par exemple dans la carte de statistiques).
  final Color divider;

  /// Contour des champs de saisie et des tracés (écrans ajoutés ensuite).
  final Color line;

  /// Couleur d'action principale.
  final Color primary;

  /// Texte et icônes posés sur [primary].
  final Color onPrimary;

  /// Statuts des signalements.
  final Color reported;
  final Color inProgress;
  final Color resolved;

  /// Urgence / alerte (rouge).
  final Color urgent;

  /// Fond de l'élément sélectionné (puce « Tous », onglet actif de la barre du bas) :
  /// #E6F7F5 en clair ET en sombre dans Figma.
  final Color selectedTint;

  /// Fond « accent » du formulaire de signalement (cercle de l'appareil photo,
  /// catégorie choisie) : #E6F4F6 en clair, #183A38 en sombre.
  final Color accentTint;

  static const light = CityAlertColors(
    background: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    text: Color(0xFF334155),
    caption: Color(0xFF64748B),
    divider: Color(0xFFE2E8F0),
    line: Color(0xFFE2E8F0),
    primary: Color(0xFF0F766E),
    onPrimary: Color(0xFFFFFFFF),
    reported: Color(0xFFB45309),
    inProgress: Color(0xFF1D4ED8),
    resolved: Color(0xFF15803D),
    urgent: Color(0xFFB91C1C),
    selectedTint: Color(0xFFE6F7F5),
    accentTint: Color(0xFFE6F4F6),
  );

  static const dark = CityAlertColors(
    background: Color(0xFF15181D),
    surface: Color(0xFF1E2229),
    text: Color(0xFFE2E8F0),
    caption: Color(0xFF94A3B8),
    divider: Color(0xFF39424F),
    line: Color(0xFF2D343D),
    primary: Color(0xFF5EEAD4),
    onPrimary: Color(0xFF15181D),
    reported: Color(0xFFE5B53A),
    inProgress: Color(0xFF6FA7EB),
    resolved: Color(0xFF59CF84),
    urgent: Color(0xFFF87171),
    selectedTint: Color(0xFFE6F7F5),
    accentTint: Color(0xFF183A38),
  );

  /// Couleur forte d'un statut.
  Color statusColor(ReportStatus status) => switch (status) {
        ReportStatus.reported => reported,
        ReportStatus.inProgress => inProgress,
        ReportStatus.resolved => resolved,
      };

  /// Version « teinte à 10 % » d'une couleur (fond des badges, etc.).
  Color tint(Color base) => base.withAlpha(26);

  @override
  CityAlertColors copyWith({
    Color? background,
    Color? surface,
    Color? text,
    Color? caption,
    Color? divider,
    Color? line,
    Color? primary,
    Color? onPrimary,
    Color? reported,
    Color? inProgress,
    Color? resolved,
    Color? urgent,
    Color? selectedTint,
    Color? accentTint,
  }) {
    return CityAlertColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      text: text ?? this.text,
      caption: caption ?? this.caption,
      divider: divider ?? this.divider,
      line: line ?? this.line,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      reported: reported ?? this.reported,
      inProgress: inProgress ?? this.inProgress,
      resolved: resolved ?? this.resolved,
      urgent: urgent ?? this.urgent,
      selectedTint: selectedTint ?? this.selectedTint,
      accentTint: accentTint ?? this.accentTint,
    );
  }

  /// Permet l'animation douce lors du changement de thème.
  @override
  CityAlertColors lerp(ThemeExtension<CityAlertColors>? other, double t) {
    if (other is! CityAlertColors) return this;
    return CityAlertColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      text: Color.lerp(text, other.text, t)!,
      caption: Color.lerp(caption, other.caption, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      line: Color.lerp(line, other.line, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      reported: Color.lerp(reported, other.reported, t)!,
      inProgress: Color.lerp(inProgress, other.inProgress, t)!,
      resolved: Color.lerp(resolved, other.resolved, t)!,
      urgent: Color.lerp(urgent, other.urgent, t)!,
      selectedTint: Color.lerp(selectedTint, other.selectedTint, t)!,
      accentTint: Color.lerp(accentTint, other.accentTint, t)!,
    );
  }
}

/// Raccourcis : `context.colors` et `context.isDark`.
extension CityAlertContext on BuildContext {
  CityAlertColors get colors => Theme.of(this).extension<CityAlertColors>()!;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
