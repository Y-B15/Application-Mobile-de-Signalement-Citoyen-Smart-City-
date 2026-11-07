import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Position trouvée par le GPS, avec son adresse lisible.
class PlaceInfo {
  const PlaceInfo({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;

  /// « 33.5731, -7.5898 » (4 décimales, comme dans la maquette).
  String get coordinates =>
      '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
}

/// Erreur de localisation avec un message prêt à afficher au citoyen.
class LocationException implements Exception {
  const LocationException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Récupère la position GPS et, si besoin, l'adresse correspondante.
class LocationService {
  const LocationService();

  /// Position + adresse lisible (formulaire « Nouveau signalement »).
  Future<PlaceInfo> currentPlace() async {
    final position = await _currentPosition();

    // Adresse lisible (si le service d'adresses échoue, on garde le GPS).
    var address = 'Position GPS';
    try {
      final marks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (marks.isNotEmpty) {
        final m = marks.first;
        final parts = <String>[
          if ((m.street ?? '').isNotEmpty) m.street!,
          if ((m.locality ?? '').isNotEmpty) m.locality!,
        ];
        if (parts.isNotEmpty) address = parts.join(', ');
      }
    } catch (_) {}

    return PlaceInfo(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
    );
  }

  /// Seulement les coordonnées (bouton « Ma position » de la carte) : plus rapide,
  /// car on ne cherche pas l'adresse.
  Future<({double latitude, double longitude})> currentCoordinates() async {
    final position = await _currentPosition();
    return (latitude: position.latitude, longitude: position.longitude);
  }

  /// Vérifie le GPS et la permission, puis lit la position (15 secondes maximum).
  Future<Position> _currentPosition() async {
    // 1. Le GPS du téléphone est-il activé ?
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException('Activez la localisation de votre téléphone.');
    }

    // 2. L'application a-t-elle la permission ?
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException(
        'Autorisez l’accès à la position pour vous localiser.',
      );
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Position refusée : autorisez-la dans les réglages du téléphone.',
      );
    }

    // 3. Position précise.
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } on TimeoutException {
      throw const LocationException('Position introuvable : réessayez.');
    }
  }
}
