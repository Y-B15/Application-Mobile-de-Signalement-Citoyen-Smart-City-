import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/state/profile_store.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decor.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/theme_controller.dart';
import '../../shared/widgets/city_app_bar.dart';
import '../../shared/widgets/city_toast.dart';
import '../../shared/widgets/city_toggle.dart';
import '../../shared/widgets/surface_card.dart';
import '../profile_edit/edit_profile_page.dart';
import 'widgets/logout_button.dart';
import 'widgets/proximity_section.dart';
import 'widgets/settings_group.dart';
import 'widgets/theme_section.dart';

/// Écran « Paramètres » (Figma : « Paramètres », clair et sombre).
///
/// Marges 16 / 8 / 16 / 24, espace de 16 entre les blocs : profil, Compte,
/// Préférences, Application, bouton « Se déconnecter ».
///
/// Les réglages sont gardés en mémoire seulement : ils ne sont pas encore
/// enregistrés sur le téléphone ni sur Firebase.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  int _radiusKm = 5;

  void _openEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const EditProfilePage()),
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text('Vous quitterez la session actuelle.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Déconnexion')),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      // Provisoire : la déconnexion réelle viendra avec Firebase Auth.
      CityToast.show(context, 'Déconnexion bientôt disponible', icon: Symbols.logout_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final overlay = (context.isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark)
        .copyWith(statusBarColor: Colors.transparent, systemNavigationBarColor: c.background);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CityAppBar(title: 'Paramètres', iconColor: c.text),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ProfileCard(onTap: _openEditProfile),
                      const SizedBox(height: 16),
                      SettingsGroup(
                        title: 'Compte',
                        children: [
                          SettingsRow(
                            icon: Symbols.person_rounded,
                            label: 'Modifier profil',
                            showChevron: true,
                            onTap: _openEditProfile,
                          ),
                          SettingsRow(
                            icon: Symbols.lock_rounded,
                            label: 'Changer le mot de passe',
                            showChevron: true,
                            onTap: () => CityToast.show(
                              context,
                              'Changement du mot de passe bientôt disponible',
                              icon: Symbols.lock_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SettingsGroup(
                        title: 'Préférences',
                        children: [
                          SettingsRow(
                            icon: Symbols.notifications_rounded,
                            label: 'Notifications push',
                            trailing: CityToggle(
                              label: 'Notifications push',
                              value: _pushNotifications,
                              onChanged: (v) => setState(() => _pushNotifications = v),
                            ),
                          ),
                          SettingsRow(
                            icon: Symbols.mail_rounded,
                            label: 'Notifications par e-mail',
                            trailing: CityToggle(
                              label: 'Notifications par e-mail',
                              value: _emailNotifications,
                              onChanged: (v) => setState(() => _emailNotifications = v),
                            ),
                          ),
                          ProximitySection(
                            km: _radiusKm,
                            onChanged: (v) => setState(() => _radiusKm = v),
                          ),
                          // Le choix du thème change tout de suite l'application.
                          ValueListenableBuilder<ThemeMode>(
                            valueListenable: themeModeNotifier,
                            builder: (context, mode, _) => ThemeSection(
                              mode: mode,
                              onChanged: (m) => themeModeNotifier.value = m,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SettingsGroup(
                        title: 'Application',
                        children: [
                          SettingsRow(
                            icon: Symbols.language_rounded,
                            label: 'Langue',
                            value: 'Français',
                            showChevron: true,
                            onTap: () => CityToast.show(
                              context,
                              'Langue : Français ✓',
                              icon: Symbols.language_rounded,
                            ),
                          ),
                          SettingsRow(
                            icon: Symbols.info_rounded,
                            label: 'À propos',
                            showChevron: true,
                            onTap: () => CityToast.show(
                              context,
                              'CityAlert · version 1.0.0',
                              icon: Symbols.info_rounded,
                            ),
                          ),
                          const SettingsRow(
                            icon: Symbols.verified_rounded,
                            label: 'Version',
                            value: '1.0.0',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LogoutButton(onPressed: _confirmLogout),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Carte du profil en haut : avatar de 56 px, nom, e-mail et chevron.
/// Figma : « Profil » (contour fin, rayon 16, padding 16, espace 14).
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return ValueListenableBuilder<UserProfile>(
      valueListenable: profileNotifier,
      builder: (context, profile, _) => SurfaceCard(
        outlined: true,
        radius: AppRadius.lg,
        padding: const EdgeInsets.all(16),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: c.tint(c.primary), shape: BoxShape.circle),
              child: Text(profile.initials, style: AppText.title(c.primary)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile.name,
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.cardTitle(c.text)),
                  const SizedBox(height: 2),
                  Text(profile.email,
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.caption(c.caption)),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Icon(Symbols.chevron_right_rounded, size: 22, color: c.caption),
          ],
        ),
      ),
    );
  }
}
