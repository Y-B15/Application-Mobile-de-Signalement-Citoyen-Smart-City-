import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../shared/widgets/city_bottom_nav.dart';
import '../../shared/widgets/city_fab.dart';

/// Page « Carte » (premier onglet de la navigation).
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_rounded, size: 80, color: c.caption),
            const SizedBox(height: 16),
            Text('Carte', style: AppText.title(c.text)),
            const SizedBox(height: 8),
            Text('Développé prochainement avec Google Maps', style: AppText.body(c.caption)),
          ],
        ),
      ),
      bottomNavigationBar: CityBottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/my-area');
          }
        },
      ),
      floatingActionButton: CityFab(
        onPressed: () => Navigator.pushNamed(context, '/report'),
      ),
    );
  }
}
