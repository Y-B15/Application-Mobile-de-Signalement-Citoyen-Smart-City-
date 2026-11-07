import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/state/profile_store.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/city_app_bar.dart';
import '../../shared/widgets/city_button.dart';
import '../../shared/widgets/city_toast.dart';
import 'widgets/avatar_editor.dart';
import 'widgets/profile_field.dart';

/// Écran « Modifier le profil » (Figma : « Modifier profil », clair et sombre).
///
/// Marges 16, espace de 16 : avatar (120 px de haut), trois champs, puis le
/// bouton « Enregistrer » (52 px, rayon 12) collé en bas.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    final p = profileNotifier.value;
    _name = TextEditingController(text: p.name);
    _email = TextEditingController(text: p.email);
    _phone = TextEditingController(text: p.phone);
    // L'avatar suit les initiales pendant la saisie.
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  /// Vérifie les champs puis enregistre. Les messages d'erreur ne sont pas
  /// dessinés dans Figma : on utilise des toasts.
  void _save() {
    final name = _name.text.trim();
    final email = _email.text.trim();

    if (name.isEmpty) {
      CityToast.show(context, 'Saisissez votre nom', icon: Symbols.person_rounded);
      return;
    }
    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!emailOk) {
      CityToast.show(context, 'Adresse e-mail invalide', icon: Symbols.mail_rounded);
      return;
    }

    profileNotifier.value = profileNotifier.value.copyWith(
      name: name,
      email: email,
      phone: _phone.text.trim(),
    );
    FocusScope.of(context).unfocus();
    CityToast.show(context, 'Profil enregistré ✓', icon: Symbols.check_circle_rounded);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final overlay = (context.isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark)
        .copyWith(statusBarColor: Colors.transparent, systemNavigationBarColor: c.background);

    // Initiales calculées avec le nom en cours de saisie.
    final initials = profileNotifier.value.copyWith(name: _name.text).initials;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                CityAppBar(title: 'Modifier le profil', iconColor: c.text),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.all(16),
                      child: ConstrainedBox(
                        // Le bouton reste en bas quand il y a de la place.
                        constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Center(
                                  child: AvatarEditor(
                                    initials: initials,
                                    onEdit: () => CityToast.show(
                                      context,
                                      'Changement de photo bientôt disponible',
                                      icon: Symbols.photo_camera_rounded,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ProfileField(
                                label: 'Nom complet',
                                icon: Symbols.person_rounded,
                                controller: _name,
                                textCapitalization: TextCapitalization.words,
                              ),
                              const SizedBox(height: 16),
                              ProfileField(
                                label: 'E-mail',
                                icon: Symbols.mail_rounded,
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              ProfileField(
                                label: 'Téléphone',
                                icon: Symbols.call_rounded,
                                controller: _phone,
                                keyboardType: TextInputType.phone,
                              ),
                              const Spacer(),
                              const SizedBox(height: 16),
                              CityButton(
                                label: 'Enregistrer',
                                radius: 12,
                                heading: true,
                                onPressed: _save,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
