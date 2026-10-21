# CityAlert (Smart City) – application Flutter

Application mobile de signalement citoyen. Le design vient du fichier Figma
**Smart City - Signalement Citoyen (Prototype)** (clé `lkcTNAc6sFyACebysE6u4M`).

**Écran codé pour l'instant : « Mon espace »** (clair + sombre, suit le thème du téléphone).

## Installation (une seule fois)

Flutter 3.24 ou plus récent recommandé.

```bash
flutter create --project-name cityalert --org ma.estsb --platforms android cityalert
cd cityalert
```

Copiez dans ce dossier, en remplaçant l'existant : `lib/`, `test/`, `pubspec.yaml`,
`analysis_options.yaml`. Supprimez `test/widget_test.dart` (test d'exemple de Flutter).

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Ajoutez la permission Internet dans `android/app/src/main/AndroidManifest.xml`,
juste avant `<application ...>` (la police Inter est téléchargée au 1er lancement,
et Firebase en aura besoin) :

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Organisation

```
lib/
  main.dart                       démarrage, thèmes clair/sombre
  core/
    theme/app_colors.dart         palette Figma (clair + sombre), context.colors
    theme/app_text.dart           7 styles Inter (Display → Caption strong)
    theme/app_decor.dart          rayons 8/12/16 + ombre « Elevation 1 »
    theme/app_theme.dart          ThemeData Material 3
    models/report.dart            Report, ReportStatus, ReportCategory
    data/reports_repository.dart  contrat + données de démo (12 = 1 + 3 + 8)
    utils/date_format.dart        « il y a 2 h », « 14 oct. »
  shared/widgets/                 briques réutilisables (cartes, badge, nav, FAB, bouton, états)
  features/my_area/               écran « Mon espace » et ses morceaux
test/date_format_test.dart
```

## Correspondance Figma → Flutter (Mon espace)

| Figma | Flutter |
|---|---|
| Styles de couleur `CityAlert/Light/*`, `Dark/*`, `Primary` | `CityAlertColors.light / .dark` |
| Styles de texte `CityAlert/Display … Caption strong` | `AppText.display … captionStrong` |
| Effet `CityAlert/Elevation 1` (Y1, flou 3, noir 8 %) | `AppShadows.elevation1` |
| Cartes blanches rayon 12 + ombre | `SurfaceCard` |
| Composant Badge | `StatusBadge` |
| Composant ReportCard (Liste) | `ReportCard` |
| États Vide / Chargement | `EmptyStateCard` / `SkeletonCard` |
| Bottom Nav (72 px) | `CityBottomNav` |
| Button / Action (56 px) | `CityFab` |
| Button / Principal | `CityButton` |

## Points de fidélité à connaître (relevés dans Figma)

- Les cartes n'ont **pas de bordure** : seulement l'ombre « Elevation 1 ».
- Dans la barre du bas, l'onglet actif est une pastille primaire pleine de 24 px,
  et son icône a la même couleur : elle est invisible dans la maquette.
  Le code reproduit cela. Si vous corrigez Figma (icône en `onPrimary`),
  changez une ligne dans `city_bottom_nav.dart`.
- Les vignettes de la liste gardent leurs pastels clairs en mode sombre (comme Figma).
- La vignette « lampadaire résolu » est bleu clair (#EFF6FF) dans Figma, alors que
  les autres résolus sont verts : reproduit tel quel, à vérifier côté design.
- Les libellés « Chargement » et « État vide » des composants Figma sont traités
  comme des étiquettes de documentation : ils ne sont pas affichés dans l'app.

## Prochaine étape

Brancher Firebase : créer `FirestoreReportsRepository` (même contrat que
`MockReportsRepository`) et le passer à `MyAreaPage`.
