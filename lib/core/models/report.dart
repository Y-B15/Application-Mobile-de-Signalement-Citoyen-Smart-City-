/// Statut d'un signalement (cycle de vie côté services de la ville).
enum ReportStatus {
  /// Reçu, pas encore pris en charge.
  reported('Signalé'),

  /// Une équipe intervient.
  inProgress('En cours'),

  /// Problème réglé.
  resolved('Résolu');

  const ReportStatus(this.label);

  /// Libellé affiché dans l'interface.
  final String label;
}

/// Catégorie d'anomalie urbaine.
enum ReportCategory {
  pothole('Nid-de-poule'),
  streetLight('Lampadaire'),
  illegalDump('Dépôt sauvage');

  const ReportCategory(this.label);
  final String label;
}

/// Un signalement effectué par un citoyen.
class Report {
  const Report({
    required this.id,
    required this.trackingNumber,
    required this.category,
    required this.title,
    required this.address,
    required this.createdAt,
    required this.status,
    this.latitude,
    this.longitude,
  });

  final String id;

  /// Numéro de suivi montré au citoyen, par exemple « CA-2048 ».
  final String trackingNumber;
  final ReportCategory category;
  final String title;
  final String address;
  final DateTime createdAt;
  final ReportStatus status;

  /// Coordonnées géographiques sur la carte.
  final double? latitude;
  final double? longitude;
}
