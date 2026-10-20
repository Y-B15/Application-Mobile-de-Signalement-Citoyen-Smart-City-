import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';

/// Logo + wordmark CityAlert utilisé sur la page de connexion.
///
/// Même composition que [OnboardingBrand] mais peut être utilisé indépendamment.
class AuthBrand extends StatelessWidget {
  const AuthBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo carré 48×48
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: c.primary,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: AppShadows.elevation1,
          ),
          child: Center(
            child: Icon(Symbols.location_on_rounded, size: 24, color: c.onPrimary),
          ),
        ),
        const SizedBox(width: 12),
        // Wordmark
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('CityAlert', style: AppText.display(c.primary)),
              const SizedBox(height: 4),
              Text(
                'Signalez les problèmes de votre quartier, suivez leur résolution.',
                style: AppText.body(c.text),
              ),
            ],
          ),
        ),
      ],
    );
  }
}