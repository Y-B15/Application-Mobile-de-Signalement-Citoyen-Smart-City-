<div align="center">

  # 🏙️ CityAlert · Smart City
  ### Application Mobile Citoyenne de Signalement d'Anomalies Urbaines

  [![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.4+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![Android](https://img.shields.io/badge/Android-API%2036-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com)
  [![Material 3](https://img.shields.io/badge/Design-Material%203-757575?style=for-the-badge&logo=materialdesign&logoColor=white)](https://m3.material.io)
  [![Theme](https://img.shields.io/badge/Theme-Clair%20%26%20Sombre-0F766E?style=for-the-badge)](https://figma.com)

  *Projet de Fin de Semestre · Application Mobile Smart City*

</div>

---

## 📖 À Propos du Projet

**CityAlert** est une application mobile moderne conçue pour transformer la gestion des services urbains en permettant aux citoyens de signaler rapidement et avec précision les dysfonctionnements de leur ville (nids-de-poule, lampadaires en panne, dépôts sauvages).

L'application est fidèle **pixel-par-pixel** à la maquette officielle **Figma** *(Smart City - Signalement Citoyen (Prototype), clé `lkcTNAc6sFyACebysE6u4M`)* avec une expérience utilisateur optimale, un mode Sombre dynamique et une intégration **Google Maps GPS en temps réel**.

> **Application ID** : `com.maville.cityalert.ma`

---

## ✨ Fonctionnalités Principales

- 🗺️ **Carte Interactive Google Maps & GPS** :
  - Localisation en temps réel du citoyen avec point de précision stylisé aux couleurs de l'application.
  - Repères colorés selon le statut du signalement (*Signalé*, *En cours*, *Résolu*).
  - Bouton de recentrage GPS sur-mesure positionné au-dessus du bouton d'action.
  - Filtres interactifs par statut (*Tous*, *Signalés*, *En cours*, *Résolus*).
  - Fiche de signalement sélectionné (`ReportSheetCard`) avec bouton d'action rapide.

- 📸 **Nouveau Signalement & Caméra** :
  - Capture photo instantanée avec l'appareil photo du smartphone ou sélection depuis la galerie.
  - Géolocalisation GPS automatique de l'anomalie avec conversion en adresse civique (*Geocoding*).
  - Sélection interactive des catégories d'anomalies (*Nid-de-poule*, *Lampadaire*, *Dépôt sauvage*).

- 👤 **Mon Espace Citoyen & Profil** :
  - Dashboard de statistiques dynamiques (*Total*, *Signalés*, *En cours*, *Résolus*).
  - Historique complet des signalements avec onglets de filtrage rapide.
  - Gestion du compte et paramètres utilisateur.

- 🎨 **Design System & Thématisation Adaptative** :
  - Palette officielle Figma avec support natif des thèmes **Clair** (`#F8FAFC`) et **Sombre** (`#15181D`).
  - Typography **Inter** (Display, Title, Card Title, Body, Caption).
  - Cartes épurées sans bordures avec ombrage doux *Elevation 1*.
  - Icônes vectorielles *Material Symbols Rounded*.

---

## 🛠️ Stack Technique & Dépendances

| Technologie / Library | Rôle & Usage |
| :--- | :--- |
| **Flutter 3.24+ / Dart 3.4+** | Framework multiplateforme réactif |
| **Google Maps Flutter** (`google_maps_flutter`) | Cartographie interactive vectorielle |
| **Geolocator** (`geolocator`) | Capture de position GPS haute précision en temps réel |
| **Geocoding** (`geocoding`) | Reverse-geocoding (coordonnées GPS → adresse civile) |
| **Image Picker** (`image_picker`) | Prise de photo caméra et sélection galerie |
| **Google Fonts Inter** (`google_fonts`) | Typographie officielle du Design System Figma |
| **Material Symbols** (`material_symbols_icons`) | Set d'icônes arrondies officielles |

---

## 📂 Architecture du Projet

```text
lib/
├── main.dart                          # Point d'entrée, routes et bascule de thème
├── core/
│   ├── data/
│   │   └── reports_repository.dart    # Contrat Repository & MockData (12 signalements)
│   ├── models/
│   │   ├── report.dart                # Modèle Report, ReportStatus, ReportCategory
│   │   └── new_report.dart            # Modèle DTO pour la création d'anomalies
│   ├── services/
│   │   └── location_service.dart      # Service GPS & Reverse-Geocoding
│   ├── theme/
│   │   ├── app_colors.dart            # Palette Figma (Clair #0F766E / Sombre #5EEAD4)
│   │   ├── app_decor.dart             # Rayons (sm 8, md 12, lg 16) & Ombre Elevation 1
│   │   ├── app_text.dart              # 7 styles typographiques Inter
│   │   └── app_theme.dart             # ThemeData Material 3 (Light & Dark)
│   └── utils/
│       └── date_format.dart           # Formateur temporel (« il y a 2 h », « 14 oct. »)
├── features/
│   ├── auth/                          # Écrans d'authentification (Connexion, Inscription, Reset)
│   ├── camera/                        # Prise de photo caméra native
│   ├── map/                           # Écran Carte Google Maps, Filtres & Fiche
│   ├── my_area/                       # Écran Mon espace, Profil & Statistiques
│   ├── new_report/                    # Écran de création d'un nouveau signalement
│   └── onboarding/                    # Slides de présentation au 1er lancement
└── shared/
    └── widgets/                       # Composants réutilisables (Card, Badge, Button, FAB)
```

---

## 🎨 Correspondance Figma → Flutter

| Composant Figma | Implémentation Flutter | Caractéristiques |
| :--- | :--- | :--- |
| **Styles de Couleur** | `CityAlertColors.light / .dark` | Primaire `#0F766E`, Fond `#F8FAFC` / `#15181D` |
| **Typographie Inter** | `AppText.display` ... `captionStrong` | Police Inter chargée dynamiquement |
| **Ombre Elevation 1** | `AppShadows.elevation1` | Y: 1, Blur: 3, Opacité: 8% noir |
| **Cartes Surface** | `SurfaceCard` | Rayon 12px, sans bordure |
| **Badges de Statut** | `StatusBadge` | Pastel 10% avec texte de couleur forte |
| **Cartes Signalement** | `ReportCard` | Vignette 40x40 avec icône de catégorie |
| **Boutons Flottants** | `CityExtendedFab` / `CityFab` | Bouton principal 56px / étendu |
| **Navigation du Bas** | `CityBottomNav` | Barre de navigation 72px avec pastille active |

---

## ⚡ Prise en Main & Installation

### Préréquis
- **Flutter SDK** : `>= 3.24.0`
- **Android Studio / VS Code**
- **Android SDK** : `compileSdk 36` (Android 16)

### Installation
```bash
# 1. Cloner le dépôt Git
git clone https://github.com/Y-B15/Application-Mobile-de-Signalement-Citoyen-Smart-City-.git
cd cityalert

# 2. Récupérer les dépendances Flutter
flutter pub get

# 3. Lancer l'analyseur de code
flutter analyze

# 4. Exécuter l'application sur émulateur ou appareil physique
flutter run
```

---

## 🔐 Configuration de la Clé API Google Maps (Sécurisée)

Pour des raisons de sécurité, la clé Google Maps API **n'est pas commitée dans le code source Git**.

Pour exécuter la carte Google Maps en local :
1. Ouvrez ou créez le fichier `android/local.properties` *(fichier ignoré par Git)*.
2. Ajoutez votre clé API Google Cloud Console :
   ```properties
   MAPS_API_KEY=votre_cle_google_maps_api_ici
   ```
3. Gradle lira automatiquement la clé lors de la compilation via `manifestPlaceholders`.

---

## 🚦 Feuille de Route (Roadmap)

- [x] **Étape 1** : Thématique complète & Design System Figma (Clair + Sombre).
- [x] **Étape 2** : Écran *Mon Espace* (Profil, Statistiques, Filtres, Rafraîchissement).
- [x] **Étape 3** : Écran *Carte* Google Maps avec GPS temps réel, marqueurs stylisés & fiche interactive.
- [x] **Étape 4** : Capture photo caméra / galerie & Reverse-Geocoding d'adresse.
- [x] **Étape 5** : Écran *Nouveau Signalement* avec sélection de catégorie.
- [ ] **Étape 6** : Intégration Firebase (Auth, Firestore `reports`, Storage `photos`).
- [ ] **Étape 7** : Suivi détaillé du signalement & Commentaires citoyens.
- [ ] **Étape 8** : Dashboard Ville (Web / Desktop).

---

<div align="center">

  **CityAlert · Smart City Signalement Citoyen**  
  *Développé dans le cadre du projet de Semester*

</div>
