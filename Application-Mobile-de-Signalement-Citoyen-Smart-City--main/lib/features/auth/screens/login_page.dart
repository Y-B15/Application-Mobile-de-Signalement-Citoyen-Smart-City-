import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../shared/widgets/city_button.dart';
import '../widgets/auth_brand.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_google_button.dart';
import '../widgets/auth_text_field.dart';

/// Écran « Connexion » (Figma : « 1 · Connexion », clair et sombre).
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthBrand(),
              const SizedBox(height: 96),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      offset: Offset(0, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Connexion', style: AppText.title(c.text)),
                    const SizedBox(height: 16),
                    const AuthTextField(
                      label: 'Adresse e-mail',
                      hintText: 'nom@exemple.com',
                      icon: Symbols.mail_rounded,
                    ),
                    const SizedBox(height: 16),
                    const AuthTextField(
                      label: 'Mot de passe',
                      hintText: '••••••••',
                      icon: Symbols.lock_rounded,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/forgot-password'),
                        child: Text(
                          'Mot de passe oublié ?',
                          style: AppText.bodyStrong(c.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CityButton(
                      label: 'Se connecter',
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const AuthDivider(),
              const SizedBox(height: 24),
              AuthGoogleButton(onPressed: () {}),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Pas encore de compte ? ', style: AppText.body(c.caption)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: Text('Créer un compte', style: AppText.bodyStrong(c.primary)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
