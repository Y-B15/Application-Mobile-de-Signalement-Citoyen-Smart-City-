import 'package:flutter/material.dart';

import '../../shared/widgets/city_bottom_nav.dart';
import '../map/map_page.dart';
import '../my_area/my_area_page.dart';

/// Onglet affiché par la coque (0 = Carte, 1 = Mon espace).
///
/// Les autres écrans le modifient pour revenir à un onglet précis, par exemple
/// « Voir sur la carte » dans l'écran de confirmation.
final ValueNotifier<int> homeTabNotifier = ValueNotifier<int>(0);

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
  int _index = homeTabNotifier.value;

  @override
  void initState() {
    super.initState();
    homeTabNotifier.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    homeTabNotifier.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (mounted) setState(() => _index = homeTabNotifier.value);
  }

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
        onTap: (i) => homeTabNotifier.value = i,
      ),
    );
  }
}
