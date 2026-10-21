/// Contenu textuel d'une diapositive d'accueil (Figma : « Onboarding 1-3 … 3-3 »).
class OnboardingSlide {
  const OnboardingSlide({required this.title, required this.description});

  final String title;
  final String description;

  /// Les trois diapositives, dans l'ordre.
  static const List<OnboardingSlide> all = [
    OnboardingSlide(
      title: 'Signalez en 30 secondes',
      description:
          'Prenez une photo, choisissez la catégorie : la position est détectée automatiquement.',
    ),
    OnboardingSlide(
      title: 'Suivez en temps réel',
      description:
          'Recevez une notification à chaque étape, de la prise en charge jusqu’à la résolution.',
    ),
    OnboardingSlide(
      title: 'Améliorez votre quartier',
      description:
          'Chaque signalement compte. Ensemble, rendons nos rues plus sûres et plus propres.',
    ),
  ];
}
