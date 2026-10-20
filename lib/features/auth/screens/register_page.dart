import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../shared/widgets/city_button.dart';
import '../widgets/auth_brand.dart';
import '../widgets/auth_text_field.dart';

/// Écran « Créer un compte » (Figma : « Créer un compte », clair et sombre).
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthBrand(),
              const SizedBox(height: 32),
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
                    Text('Créer un compte', style: AppText.title(c.text)),
                    const SizedBox(height: 16),
                    const AuthTextField(
                      label: 'Nom complet',
                      hintText: 'Prénom Nom',
                      icon: Symbols.person_rounded,
                    ),
                    const SizedBox(height: 16),
                    const AuthTextField(
                      label: 'Adresse e-mail',
                      hintText: 'nom@exemple.com',
                      icon: Symbols.mail_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    const AuthTextField(
                      label: 'Mot de passe',
                      hintText: '••••••••',
                      icon: Symbols.lock_rounded,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    CityButton(
                      label: 'S\'inscrire',
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 1,
                color: c.line,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Déjà un compte ?', style: AppText.body(c.caption)),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text('Se connecter', style: AppText.bodyStrong(c.primary)),
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
