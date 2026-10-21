import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/data/reports_repository.dart';
import '../../core/models/report.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decor.dart';
import '../../core/theme/app_text.dart';
import '../../features/my_area/report_filter.dart';
import '../../shared/widgets/city_bottom_nav.dart';
import '../../shared/widgets/city_fab.dart';
import '../../shared/widgets/surface_card.dart';
import 'widgets/custom_map_canvas.dart';
import 'widgets/map_selected_card.dart';

/// Page « Carte » (Premier onglet de l'application).
///
/// Propose une carte interactive vectorielle et GPS en temps réel
/// sans risque d'écran blanc ou de dépendance réseau.
/// Affiche la position de l'utilisateur, les signalements avec repères colorés
/// selon leur statut et la fiche détaillée lors de la sélection.
class MapPage extends StatefulWidget {
  const MapPage({super.key, this.repository = const MockReportsRepository()});

  final ReportsRepository repository;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Position initiale centrée sur Casablanca
  double _mapCenterLat = 33.5820;
  double _mapCenterLng = -7.6200;

  List<Report> _reports = [];
  Report? _selectedReport;
  ReportFilter _filter = ReportFilter.all;
  bool _isLoading = true;
  Position? _userPosition;
  bool _hasGpsPermission = false;

  @override
  void initState() {
    super.initState();
    _loadReports();
    _initGps();
  }

  /// Initialise la géolocalisation GPS réelle de l'utilisateur.
  Future<void> _initGps() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        if (!mounted) return;
        setState(() {
          _userPosition = pos;
          _hasGpsPermission = true;
          _mapCenterLat = pos.latitude;
          _mapCenterLng = pos.longitude;
        });
      } catch (_) {
        // En cas d'erreur de capteur GPS, conserver les coordonnées de Casablanca
      }
    }
  }

  /// Charge les signalements depuis le dépôt.
  Future<void> _loadReports() async {
    try {
      final reports = await widget.repository.fetchMyReports();
      if (!mounted) return;
      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  /// Recentrer la carte sur la position GPS réelle de l'utilisateur
  void _recenterOnUser() {
    if (_userPosition != null) {
      setState(() {
        _mapCenterLat = _userPosition!.latitude;
        _mapCenterLng = _userPosition!.longitude;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Carte recentrée sur votre position GPS'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      _initGps();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDark = context.isDark;

    final visibleReports = _reports.where(_filter.matches).toList();

    final overlay = (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
        .copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: c.surface,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        body: Stack(
          children: [
            // Carte vectorielle interactive & GPS
            CustomMapCanvas(
              centerLat: _mapCenterLat,
              centerLng: _mapCenterLng,
              reports: visibleReports,
              selectedReport: _selectedReport,
              userPosition: _userPosition,
              onReportSelected: (report) {
                setState(() => _selectedReport = report);
              },
            ),

            // Barre de filtre supérieure
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // Filtres par statut
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChip(
                              label: 'Tous (${_reports.length})',
                              isSelected: _filter == ReportFilter.all,
                              onTap: () => setState(() => _filter = ReportFilter.all),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Signalés',
                              isSelected: _filter == ReportFilter.reported,
                              color: c.reported,
                              onTap: () => setState(() => _filter = ReportFilter.reported),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'En cours',
                              isSelected: _filter == ReportFilter.inProgress,
                              color: c.inProgress,
                              onTap: () => setState(() => _filter = ReportFilter.inProgress),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Résolus',
                              isSelected: _filter == ReportFilter.resolved,
                              color: c.resolved,
                              onTap: () => setState(() => _filter = ReportFilter.resolved),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Bouton GPS
                    Material(
                      elevation: 2,
                      shadowColor: Colors.black12,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      color: c.surface,
                      child: InkWell(
                        onTap: _recenterOnUser,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Symbols.my_location_rounded,
                            size: 20,
                            color: _hasGpsPermission ? c.primary : c.caption,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Indicateur d'état GPS en haut si disponible
            if (_userPosition != null)
              Positioned(
                top: 75,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    boxShadow: AppShadows.elevation1,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: c.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'GPS Actif (${_userPosition!.latitude.toStringAsFixed(2)}, ${_userPosition!.longitude.toStringAsFixed(2)})',
                        style: AppText.caption(c.caption),
                      ),
                    ],
                  ),
                ),
              ),

            // Chargement initial
            if (_isLoading)
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: SurfaceCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: c.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('Chargement des signalements...', style: AppText.caption(c.text)),
                      ],
                    ),
                  ),
                ),
              ),

            // Fiche du signalement sélectionné
            if (_selectedReport != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 95,
                child: MapSelectedCard(
                  report: _selectedReport!,
                  onClose: () => setState(() => _selectedReport = null),
                  onDetailTap: () {
                    Navigator.pushNamed(
                      context,
                      '/report-detail',
                      arguments: _selectedReport,
                    );
                  },
                ),
              ),

            // Bouton flottant « Signaler »
            Positioned(
              right: 16,
              bottom: _selectedReport != null ? 220 : 19,
              child: CityFab(
                onPressed: () => Navigator.pushNamed(context, '/report'),
              ),
            ),
          ],
        ),

        // Barre de navigation inférieure
        bottomNavigationBar: CityBottomNav(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.pushReplacementNamed(context, '/my-area');
            }
          },
        ),
      ),
    );
  }
}

/// Chip de filtrage personnalisée pour la barre supérieure.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final activeColor = color ?? c.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : c.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          boxShadow: AppShadows.elevation1,
        ),
        child: Text(
          label,
          style: isSelected
              ? AppText.captionStrong(c.onPrimary)
              : AppText.caption(c.text),
        ),
      ),
    );
  }
}
