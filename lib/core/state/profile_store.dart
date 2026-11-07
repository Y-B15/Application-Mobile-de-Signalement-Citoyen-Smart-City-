import 'package:flutter/foundation.dart';

/// Profil de l'utilisateur connecté.
///
/// Démonstration : valeurs fixes en mémoire. Plus tard ces données viendront de
/// Firebase Auth et de Firestore.
class UserProfile {
  const UserProfile({required this.name, required this.email, required this.phone});

  final String name;
  final String email;
  final String phone;

  /// « Yassine B. » devient « YB ».
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  UserProfile copyWith({String? name, String? email, String? phone}) => UserProfile(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
      );
}

/// Profil courant : les écrans qui l'affichent se mettent à jour tout seuls
/// quand « Modifier le profil » l'enregistre.
final ValueNotifier<UserProfile> profileNotifier = ValueNotifier<UserProfile>(
  const UserProfile(
    name: 'Yassine B.',
    email: 'yassine.b@email.com',
    phone: '+212 6 12 34 56 78',
  ),
);
