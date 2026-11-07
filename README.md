# CityAlert (Smart City) – application Flutter

Application mobile de signalement citoyen. Le design vient du fichier Figma
**Smart City - Signalement Citoyen (Prototype)** (clé `lkcTNAc6sFyACebysE6u4M`).

**Écrans codés : « Onboarding » (3 diapositives), « Carte », « Mon espace », « Nouveau signalement », « Prise de photo », « Confirmation », « Détail du signalement » « Commentaires », « Paramètres » et « Modifier le profil »** (clair + sombre, suit le thème du téléphone). L'application démarre sur l'accueil ; « Passer » / « Commencer » ouvre « Mon espace » en attendant l'écran de connexion.

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

## Google Maps (obligatoire pour l'écran Carte)

1. Console Google Cloud : créez un projet, activez **Maps SDK for Android** et
   créez une **clé API** (la facturation doit être activée ; l'usage de test reste dans le quota gratuit).
2. Dans `android/app/src/main/AndroidManifest.xml`, **à l'intérieur** de `<application ...>` :

```xml
<meta-data android:name="com.google.android.geo.API_KEY" android:value="VOTRE_CLE_API"/>
```

3. Si Gradle se plaint de la version minimale, mettez `minSdk = 21` (ou 23) dans
   `android/app/build.gradle(.kts)`.
4. Ne publiez jamais la clé sur GitHub ; restreignez-la à votre application
   (nom de package + empreinte SHA-1) dans la console Google Cloud.

Sans clé, la carte s'affiche grise : c'est normal.

## Appareil photo, galerie et GPS (formulaire de signalement)

Dans `android/app/src/main/AndroidManifest.xml`, **avant** `<application ...>`, ajoutez :

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

Dans `android/app/build.gradle(.kts)`, `minSdk` doit valoir au moins 21.
Testez la caméra sur un vrai téléphone : l'émulateur n'a qu'une caméra simulée.

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
  features/onboarding/            accueil : 3 diapositives, points, illustrations
  features/home/home_shell.dart   coque : barre du bas Carte / Mon espace
  features/map/                   écran « Carte » : Google Maps, repères, filtres, fiche
  features/new_report/            formulaire « Nouveau signalement » (photo, GPS, catégorie, texte)
  features/camera/                écran « Prise de photo » (plugin camera)
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
| Bottom Nav (72 px) | `CityBottomNav` (style de l'écran Carte, voir ci-dessous) |
| Pin/… (40 × 44), Search, Filters | `MarkerIconFactory`, `MapSearchBar`, `MapFilterChips` |
| ReportCard « Fiche » | `ReportSheetCard` |
| Button « Action étendue » | `CityExtendedFab` |
| Button Secondaire / Photo | `CityButton(style: secondary)` / `CityButton(compact: true)` |
| App Bar (56 px) | `CityAppBar` |
| Photo / Location / Category / Description | `PhotoSection`, `LocationSection`, `CategorySection`, `DescriptionField` |
| Button / Action (56 px) | `CityFab` |
| Button / Principal | `CityButton` |

## Points de fidélité à connaître (relevés dans Figma)

- Les cartes n'ont **pas de bordure** : seulement l'ombre « Elevation 1 ».
- **Barre du bas** : Figma la dessine de deux façons. Sur « Carte », l'onglet actif a une
  pastille #E6F7F5, une icône et un libellé primaires. Sur « Mon espace », la pastille est
  primaire pleine et l'icône disparaît dedans. Le code utilise le style de la Carte pour
  les deux écrans ; la version de « Mon espace » ressemble à une erreur dans la maquette.
- Les vignettes de la liste gardent leurs pastels clairs en mode sombre (comme Figma).
- La vignette « lampadaire résolu » est bleu clair (#EFF6FF) dans Figma, alors que
  les autres résolus sont verts : reproduit tel quel, à vérifier côté design.
- Les libellés « Chargement » et « État vide » des composants Figma sont traités
  comme des étiquettes de documentation : ils ne sont pas affichés dans l'app.

## Prochaine étape

Brancher Firebase : créer `FirestoreReportsRepository` (même contrat que
`MockReportsRepository`) et le passer à `MyAreaPage`.

## Écran Carte : points à valider

- Le fond de carte vient de Google Maps (styles clair et sombre dans `map_styles.dart`) :
  les couleurs s'approchent de la maquette, mais le tracé des rues et les noms sont ceux de Google.
- Les repères sont dessinés avec le tracé exact de la goutte Figma (36 × 40, contour 3 px).
- États non dessinés dans Figma et déduits : puce de statut sélectionnée (fond #E6F7F5, sans ombre)
  et puce « Tous » non sélectionnée (fond surface avec ombre).
- La puce « Tous » du mode sombre garde le fond clair #E6F7F5 comme dans Figma.
- Le repère touché n'a pas d'aspect particulier dans Figma : seule la fiche apparaît.

## Formulaire « Nouveau signalement » et « Prise de photo » : points à valider

- **Titre invisible en sombre dans Figma** : le titre « Nouveau signalement » du mode sombre a la
  couleur du mode clair (#181B22) sur fond sombre. Le code utilise la couleur de texte du thème.
- États non dessinés dans Figma et déduits : photo choisie (miniature à la place de la pastille,
  boutons « Reprendre » / « Galerie »), position en recherche ou en erreur (avec « Réessayer »),
  bouton d'envoi en chargement, caméra refusée ou indisponible.
- Le viseur de Figma montre une scène dessinée ; dans l'app il affiche la vraie caméra,
  avec la grille, les quatre coins et le conseil « Cadrez le problème » par-dessus.
- Le zoom bascule entre 1× et 2×. L'éclair est « activé / désactivé ».
- « Modifier » (position) affiche « bientôt disponible » : il ouvrira un choix sur la carte plus tard.
- À l'envoi, le numéro de suivi est fictif (`CA-2050`) et un message s'affiche ; l'écran
  « Confirmation » le remplacera à l'étape suivante.

## Confirmation et Détail du signalement : points à valider

- Historique : Figma dessine l'état « Signalé » et l'état « En cours ». L'état « Résolu » (toutes les étapes faites) est déduit.
- Les coches des points sont blanches (lues en mode clair ; à vérifier en sombre dans Figma).
- La puce du service (« Voirie ») vient de la catégorie : nid-de-poule = Voirie, lampadaire = Éclairage public, dépôt sauvage = Propreté.
- La photo du détail est un espace gris pour l'instant (pas de photo de démonstration).
- « Voir sur la carte » et « Retour à l'accueil » ramènent tous les deux à l'onglet Carte.

## Commentaires et toasts : points à valider

- **Accès aux commentaires** : Figma ne montre pas comment on y arrive. J'ai ajouté une ligne
  « Commentaires et soutiens » en bas du détail du signalement (hors maquette).
- **Toasts** : `CityToast` reproduit les messages de Figma (fond « texte », rayon 12, centré à 96 px du bas).
  Déjà utilisé pour « Commentaire envoyé ✓ », « Lien copié ✓ », « Numéro copié ✓ » et « Options bientôt disponibles ».
- États non dessinés et déduits : bouton « Soutenu (+25) » après le toucher ; « Répondre » place « @Prénom » dans le champ ;
  « Plus récents » affiche « Options bientôt disponibles » ; bouton d'envoi estompé quand le champ est vide.
- Dans Figma la ligne d'une réponse officielle déborde à droite (nom + pastille + date) : ici la date passe à la ligne.
- Le titre « Commentaires (7) » compte les commentaires chargés ; la démo en contient 7.

## Bouton « Ma position » (écran Carte)

- Ajout hors maquette : carré de 48 px au-dessus de « Signaler », même style que le bouton « Partager ».
- Il lit le GPS, affiche le point bleu et centre la carte sur vous (zoom 17).
- Si le GPS est coupé ou la permission refusée, un message s'affiche (toast).
- Il utilise les permissions de localisation déjà ajoutées pour le formulaire de signalement.

## Messages temporaires (toasts)

Tous les anciens messages (SnackBar) sont remplacés par `CityToast` (style Figma) : Carte, Mon espace,
Nouveau signalement et Prise de photo (« Photo ajoutée ✓ », « Flash activé », « Caméra retournée »).

## Envoyer le code sans dépasser la taille maximale

Les dossiers `build`, `.dart_tool` et `android\.gradle` pèsent des centaines de Mo : ne les zippez pas.
Envoyez seulement `lib`, `test`, `pubspec.yaml` et `android\app\src\main\AndroidManifest.xml`,
ou lancez `flutter clean` avant de zipper le dossier.

## Paramètres et Modifier le profil : points à valider

- Ces deux écrans de Figma utilisent un **contour fin de 1 px** (et pas d'ombre) sur leurs cartes, contrairement aux autres écrans :
  reproduit avec `SurfaceCard(outlined: true)`. Le bouton « Enregistrer » a un rayon de 12 et un texte 16/24 (`CityButton(radius: 12, heading: true)`).
- Le **choix du thème** (Clair / Sombre / Auto) change l'application tout de suite grâce à `themeModeNotifier` : `main.dart` doit l'écouter.
- Les réglages (notifications, rayon de proximité, thème) sont gardés **en mémoire** : ils ne sont pas encore enregistrés.
- États non dessinés et déduits : contour primaire d'un champ actif ; messages d'erreur du profil (toasts « Saisissez votre nom », « Adresse e-mail invalide ») ;
  toast « Profil enregistré ✓ ».
- Le contour blanc du bouton du curseur est blanc en clair comme en sombre (Figma : #FFFFFF).
- « Changer le mot de passe » et « Se déconnecter » affichent « bientôt disponible » (Firebase Auth plus tard).
