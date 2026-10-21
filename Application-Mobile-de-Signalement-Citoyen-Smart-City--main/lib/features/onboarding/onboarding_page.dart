import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../shared/widgets/city_button.dart';
import 'onboarding_slide.dart';
import 'widgets/onboarding_illustration.dart';
import 'widgets/page_dots.dart';

/// Écrans d'accueil (3 diapositives) : illustration, titre, texte, points
/// indicateurs, bouton « Suivant » puis « Commencer », lien « Passer ».
///
/// On peut aussi glisser le doigt pour changer de diapositive.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.onFinished});

  /// Appelée par « Passer » et par « Commencer » (ira vers la connexion).
  final VoidCallback onFinished;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;

  bool get _isLast => _index == OnboardingSlide.all.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_isLast) {
      widget.onFinished();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const slides = OnboardingSlide.all;

    final overlay = (context.isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark)
        .copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: c.background,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Ligne « Passer » (disparaît sur la dernière diapositive).
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isLast ? 0 : 1,
                    child: IgnorePointer(
                      ignoring: _isLast,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: widget.onFinished,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text('Passer', style: AppText.bodyStrong(c.caption)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: slides.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) => _SlideView(index: i, slide: slides[i]),
                ),
              ),
              // Pied fixe : points + bouton (ne glisse pas avec les pages).
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PageDots(count: slides.length, current: _index),
                    const SizedBox(height: 20),
                    CityButton(
                      label: _isLast ? 'Commencer' : 'Suivant',
                      onPressed: _next,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Une diapositive : illustration en haut, texte centré, espaces égaux.
/// Défile si l'écran est trop petit (petits téléphones, grande police).
class _SlideView extends StatelessWidget {
  const _SlideView({required this.index, required this.slide});

  final int index;
  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // FittedBox réduit l'illustration sur les écrans très étroits.
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: OnboardingIllustration(index: index),
                    ),
                    const Spacer(),
                    Text(
                      slide.title,
                      textAlign: TextAlign.center,
                      style: AppText.display(c.text),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      slide.description,
                      textAlign: TextAlign.center,
                      style: AppText.body(c.caption),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
