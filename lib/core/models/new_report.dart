import 'report.dart';

/// Données saisies dans le formulaire « Nouveau signalement », prêtes à être
/// envoyées (Firestore pour le texte et la position, Storage pour la photo).
class NewReport {
  const NewReport({
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.photoPath,
  });

  final ReportCategory category;

  /// Texte libre (0 à 300 caractères, peut être vide).
  final String description;
  final double latitude;
  final double longitude;

  /// Adresse lisible trouvée à partir du GPS (« Rue Hassan II, Casablanca »).
  final String address;

  /// Chemin local de la photo (appareil photo ou galerie), s'il y en a une.
  final String? photoPath;
}
