import 'report.dart';

/// Un signalement avec tout ce qu'il faut pour l'écran « Détail du signalement » :
/// description et dates de chaque étape de l'historique.
class ReportDetail {
  const ReportDetail({
    required this.report,
    required this.fullAddress,
    required this.description,
    this.takenAt,
    this.interventionAt,
    this.interventionNote,
    this.resolvedAt,
  });

  final Report report;

  /// Adresse complète (« Rue Hassan II, Casablanca »).
  final String fullAddress;
  final String description;

  /// Date de prise en charge par le service municipal (null = pas encore).
  final DateTime? takenAt;

  /// Date de début de l'intervention et petite précision (« équipe sur place »).
  final DateTime? interventionAt;
  final String? interventionNote;

  /// Date de résolution (null = pas encore résolu).
  final DateTime? resolvedAt;
}
