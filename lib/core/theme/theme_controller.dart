import 'package:flutter/material.dart';

/// Thème choisi dans « Paramètres » (Clair / Sombre / Auto = celui du téléphone).
///
/// `main.dart` écoute cette valeur et reconstruit l'application quand elle change.
/// Plus tard on l'enregistrera sur le téléphone pour le retrouver au lancement.
final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.system);
