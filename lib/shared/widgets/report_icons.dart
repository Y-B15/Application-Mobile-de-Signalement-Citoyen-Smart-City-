import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/models/report.dart';

/// Icône Material Symbols Rounded de chaque catégorie (identique à Figma).
/// Utilisée par les cartes de signalement et par les repères de la carte.
extension ReportCategoryIcon on ReportCategory {
  IconData get icon => switch (this) {
        ReportCategory.pothole => Symbols.construction_rounded,
        ReportCategory.streetLight => Symbols.lightbulb_rounded,
        ReportCategory.illegalDump => Symbols.delete_rounded,
      };
}
