import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/screens/forgot_password_page.dart';
import 'features/auth/screens/login_page.dart';
import 'features/auth/screens/register_page.dart';
import 'features/auth/screens/reset_sent_page.dart';
import 'features/map/map_page.dart';
import 'features/my_area/my_area_page.dart';
import 'features/onboarding/onboarding_page.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CityAlertApp());
}

/// Racine de l'application CityAlert.
class CityAlertApp extends StatelessWidget {
  const CityAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityAlert',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingPage(
          onFinished: () => Navigator.pushReplacementNamed(context, '/login'),
        ),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/auth/reset-sent': (context) => const ResetSentPage(),
        '/home': (context) => const MapPage(),
        '/map': (context) => const MapPage(),
        '/my-area': (context) => const MyAreaPage(),
        '/report': (context) => const ReportPage(),
        '/report-detail': (context) => const ReportDetailPage(),
      },
    );
  }
}

/// Page d'accueil après onboarding : contient la navigation principale.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const MapPage(),
      const MyAreaPage(),
    ];

    return IndexedStack(
      index: _currentIndex,
      children: [
        for (final p in pages)
          if (p is MapPage)
            p
          else
            p,
      ],
    ).build(context);
  }
}

/// Écran pour créer un nouveau signalement.
class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: c.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Nouveau signalement', style: AppText.title(c.text)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_rounded, size: 80, color: c.caption),
            const SizedBox(height: 16),
            Text('Nouveau signalement', style: AppText.title(c.text)),
            const SizedBox(height: 8),
            Text('Ajoutez une photo et une description', style: AppText.body(c.caption)),
          ],
        ),
      ),
    );
  }
}

/// Écran de détail et suivi d'un signalement.
class ReportDetailPage extends StatelessWidget {
  const ReportDetailPage({super.key});

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
        title: Text('Suivi du signalement', style: AppText.title(c.text)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 80, color: c.caption),
            const SizedBox(height: 16),
            Text('Suivi du signalement', style: AppText.title(c.text)),
            const SizedBox(height: 8),
            Text('Vos commentaires et historique', style: AppText.body(c.caption)),
          ],
        ),
      ),
    );
  }
}
