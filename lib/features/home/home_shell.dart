import 'package:flutter/material.dart';

import '../../shared/widgets/city_bottom_nav.dart';
import '../map/map_page.dart';
import '../my_area/my_area_page.dart';

/// Coque de l'application une fois connecté : la barre de navigation du bas
/// (Carte / Mon espace) et les pages principales.
///
/// `IndexedStack` garde les deux pages en vie : revenir sur la carte ne
/// recharge pas Google Maps et conserve la position et la fiche ouverte.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0; // 0 = Carte (écran d'accueil), 1 = Mon espace

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          MapPage(),
          MyAreaPage(),
        ],
      ),
      bottomNavigationBar: CityBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
