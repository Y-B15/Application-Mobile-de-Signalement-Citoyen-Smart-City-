import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';
import '../../../core/theme/app_text.dart';

/// Bouton de connexion Google (Figma : « btn-google »).
class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: AppShadows.elevation1,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Note : En prod, utiliser une vraie image d'icône Google.
                // Ici on simule avec un rond de couleur pour le design.
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red, // Simule le logo Google
                  ),
                  margin: const EdgeInsets.only(right: 12),
                ),
                Text(
                  'Continuer avec Google',
                  style: AppText.bodyStrong(c.text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
