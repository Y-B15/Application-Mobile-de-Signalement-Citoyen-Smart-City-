# Prompt à copier dans une nouvelle conversation

Colle tout ce qui suit dans une nouvelle conversation avec Claude. Joins aussi le
dossier `cityalert/` (ou le zip) et vérifie que le connecteur Figma est actif.

---

Tu continues le développement de l'application mobile **CityAlert** (signalement
citoyen Smart City, projet de stage ESTSB / OCP, soutenance dans environ 2 mois).
Objectif : une application Flutter **identique au design Figma, pixel pour pixel**,
en français, thèmes clair et sombre. Je ne veux aucune précipitation : un écran à
la fois, parfait, avec des commentaires en français dans le code.

## Figma
- Fichier : `lkcTNAc6sFyACebysE6u4M` (« Smart City - Signalement Citoyen (Prototype) »).
- Lis les mesures exactes avec l'outil Figma (`use_figma`) avant de coder chaque
  écran. Ne devine jamais une valeur. Ne modifie pas le design sans me le demander.
- Page « Prototype » (écrans de base, 360 px) : Connexion L 11:42 / S 11:425 ;
  Carte L 11:84 / S 11:467 ; Carte avec signalement sélectionné L 37:355 / S 62:171 ;
  Nouveau signalement L 11:194 / S 11:577 ; Suivi du signalement L 11:253 / S 11:636 ;
  **Mon espace L 11:323 / S 11:706 (déjà codé)**.
- Page « Nouveaux écrans » (L = clair, S = sombre) :
  Onboarding 1/2/3 L 55:182, 55:217, 55:259 / S 55:410, 55:445, 55:487 ;
  Créer un compte L 55:301 / S 55:529 ; Mot de passe oublié L 55:355 / S 55:583 ;
  Lien envoyé L 55:385 / S 55:613 ; Catégories L 56:197 / S 56:386 ;
  Prise de photo L 56:286 / S 56:475 ; Confirmation L 56:334 / S 56:523 ;
  Notifications L 60:205 / S 60:514 ; Badges L 60:273 / S 60:582 ;
  Statistiques L 60:362 / S 60:671 ; Commentaires L 61:205 / S 61:319 ;
  Dashboard Ville (bureau, sombre) 61:433.
- Page « CityAlert · Composants » : Button (12 variantes), Badge (6), ReportCard (14).

## Design system (déjà dans `lib/core/theme/`)
- Primaire #0F766E (sombre #5EEAD4). Statuts : Signalé #B45309, En cours #1D4ED8,
  Résolu #15803D (sombre #E5B53A, #6FA7EB, #59CF84).
- Fond clair #F8FAFC / sombre #15181D ; surface #FFFFFF / #1E2229 ; texte #334155 / #E2E8F0 ;
  caption #64748B / #94A3B8 ; urgent #B91C1C / #F87171.
- Police Inter : Display 28/36 Bold, Title 20/28 SemiBold, Card title 16/24 SemiBold,
  Body 14/20, Body strong 14/20 SemiBold, Caption 12/16, Caption strong 12/16 SemiBold.
- Rayons 8 / 12 / 16. Cartes SANS bordure, avec l'ombre « Elevation 1 »
  (noir 8 %, Y 1, flou 3). Icônes : Material Symbols Rounded (`material_symbols_icons`).
- Les écrans ajoutés (11 nouveaux) utilisent aussi : ligne/contour `line` (#E2E8F0 / #2D343D),
  teinte primaire à 10 %, « onPrimary à 25 % ». Si un style manque dans `app_colors.dart`, ajoute-le.

## Déjà fait
- Projet `cityalert/` : thème exact (couleurs, textes, ombre, rayons), modèle Report,
  dépôt de données `ReportsRepository` (version démo `MockReportsRepository`),
  utilitaire de date, widgets partagés (`SurfaceCard`, `StatusBadge`, `ReportCard`,
  `CityBottomNav`, `CityFab`, `CityButton`, états vide/chargement/erreur) et l'écran
  **Mon espace** complet (profil, statistiques, compte, onglets, liste, rafraîchissement).
- Rien n'a pu être compilé dans mon environnement (pas de Flutter) : lance
  `flutter pub get`, `flutter analyze` et `flutter run`, et corrige les erreurs éventuelles en premier.

## À faire, dans cet ordre (un écran à la fois, clair + sombre à chaque fois)
1. Vérifier que Mon espace compile et se compare bien à Figma (captures côte à côte).
2. Carte (+ variante « signalement sélectionné ») : Google Maps Flutter, repères colorés
   par statut, fiche en bas, bouton « Signaler ».
3. Nouveau signalement + Prise de photo (plugin camera, géolocalisation GPS).
4. Suivi du signalement (détail + historique) puis Commentaires.
5. Connexion, Créer un compte, Mot de passe oublié (Firebase Auth), Onboarding.
6. Confirmation, Catégories, Notifications, Badges, Statistiques.
7. Navigation complète (routes, barre du bas à 2 puis 3 onglets selon Figma).
8. Firebase : Auth, Firestore (collection `reports`), Storage (photos) ; remplacer
   `MockReportsRepository` par une version Firestore sans changer les écrans.
9. Dashboard Ville (version bureau / web) : en dernier.
10. Livrables : APK installable, code commenté, documentation de la configuration
    Firebase, mini-rapport de conception, rapport final.

## Règles de travail
- Avant chaque écran : lire Figma, lister les mesures, puis coder. Après : m'indiquer
  les écarts éventuels entre Figma et le code.
- Pas de bordure sur les cartes ; pas de `withOpacity` ni de `CardTheme` (versions
  de Flutter différentes) ; utiliser `withAlpha`.
- Code commenté en français, noms de fichiers en anglais, un widget par fichier si réutilisable.
- Réponds-moi en français, simplement.
- Si tu atteins la limite de conversation, termine par un nouveau prompt de passation
  du même format que celui-ci.
