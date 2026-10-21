import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../shared/widgets/city_button.dart';

/// Écran « Lien envoyé » (Figma : « Lien envoyé », clair et sombre).
class ResetSentPage extends StatelessWidget {
  const ResetSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: c.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: c.tint(c.primary),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Symbols.mark_email_unread_rounded,
                        size: 40,
                        color: c.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Lien de réinitialisation envoyé',
                      style: AppText.title(c.text),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nous avons envoyé un lien de réinitialisation à votre adresse e-mail. Vérifiez votre boîte de réception.',
                      style: AppText.body(c.caption),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              CityButton(
                label: 'Retour à la connexion',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
