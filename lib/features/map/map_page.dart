import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/data/reports_repository.dart';
import '../../core/models/report.dart';
import '../../core/services/location_service.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/city_extended_fab.dart';
import '../../shared/widgets/city_toast.dart';
import '../../shared/widgets/report_icons.dart';
import '../new_report/new_report_page.dart';
import '../report_detail/report_detail_page.dart';
import 'map_styles.dart';
import 'marker_icon_factory.dart';
import 'widgets/locate_button.dart';
import 'widgets/map_filter_chips.dart';
import 'widgets/map_search_bar.dart';
import 'widgets/report_sheet_card.dart';

/// Écran « Carte » (Figma : « 2 · Carte » et « 2.2 · Carte après clic »).
///
/// Une carte Google Maps plein écran, sous : la barre de recherche, les puces
/// de filtre, le bouton « Signaler » et, quand on touche un repère, la fiche du
/// signalement. La barre du bas est fournie par `HomeShell`.
class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
    ReportsRepository? repository,
    this.locationService = const LocationService(),
  }) : repository = repository ?? const MockReportsRepository();

  final ReportsRepository repository;
  final LocationService locationService;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  /// Centre de la carte : Casablanca, zoom 16 (comme la maquette).
  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(33.5883, -7.6322),
    zoom: 16,
  );

  // Utilisateur de démonstration (viendra de Firebase Auth plus tard).
  static const String _userInitials = 'YB';

  List<Report> _reports = const [];
  ReportStatus? _statusFilter; // null = « Tous »
  Report? _selected;

  /// Dernière fiche affichée : on la garde pour qu'elle reste visible
  /// pendant son animation de sortie.
  Report? _sheetReport;

  /// Images des repères, une par couple catégorie + statut.
  Map<String, BitmapDescriptor> _icons = const {};
  Brightness? _iconsBrightness;
  double? _iconsRatio;

  /// Contrôleur de la carte : sert à déplacer la caméra (bouton « Ma position »).
  GoogleMapController? _mapController;
  bool _isLocating = false;

  /// Affiche le point bleu de l'utilisateur, une fois la permission accordée.
  bool _showMyLocation = false;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buildIcons(); // à refaire si le thème ou la densité d'écran change
  }

  Future<void> _loadReports() async {
    try {
      final reports = await widget.repository.fetchMapReports();
      if (!mounted) return;
      setState(() => _reports = reports);
    } catch (_) {
      if (!mounted) return;
      _showMessage('Impossible de charger les signalements.');
    }
  }

  /// Dessine les 9 repères (3 catégories × 3 statuts) aux couleurs du thème.
  Future<void> _buildIcons() async {
    final brightness = Theme.of(context).brightness;
    final ratio = MediaQuery.devicePixelRatioOf(context);
    if (_iconsBrightness == brightness && _iconsRatio == ratio) return;
    _iconsBrightness = brightness;
    _iconsRatio = ratio;

    final colors = brightness == Brightness.dark
        ? CityAlertColors.dark
        : CityAlertColors.light;

    final next = <String, BitmapDescriptor>{};
    for (final status in ReportStatus.values) {
      for (final category in ReportCategory.values) {
        next[_iconKey(category, status)] = await MarkerIconFactory.pin(
          icon: category.icon,
          color: colors.statusColor(status),
          fill: colors.surface,
          pixelRatio: ratio,
        );
      }
    }
    if (!mounted) return;
    setState(() => _icons = next);
  }

  static String _iconKey(ReportCategory c, ReportStatus s) => '${c.name}-${s.name}';

  List<Report> get _visibleReports => _statusFilter == null
      ? _reports
      : _reports.where((r) => r.status == _statusFilter).toList();

  Set<Marker> _buildMarkers() {
    // On attend que les images soient prêtes pour éviter les repères rouges par défaut.
    if (_icons.isEmpty) return const {};

    return {
      for (final r in _visibleReports)
        if (r.latitude != null && r.longitude != null)
          Marker(
            markerId: MarkerId(r.id),
            position: LatLng(r.latitude!, r.longitude!),
            icon: _icons[_iconKey(r.category, r.status)] ??
                BitmapDescriptor.defaultMarker,
            anchor: MarkerIconFactory.anchor,
            onTap: () => setState(() {
              _selected = r;
              _sheetReport = r;
            }),
          ),
    };
  }

  /// Bouton « Ma position » : lit le GPS puis centre la carte sur l'utilisateur.
  Future<void> _goToMyLocation() async {
    if (_isLocating) return;
    setState(() => _isLocating = true);
    try {
      final here = await widget.locationService.currentCoordinates();
      if (!mounted) return;
      setState(() => _showMyLocation = true); // point bleu (permission accordée)
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(here.latitude, here.longitude), 17),
      );
    } on LocationException catch (e) {
      if (!mounted) return;
      CityToast.show(context, e.message, icon: Symbols.location_off_rounded);
    } catch (_) {
      if (!mounted) return;
      CityToast.show(context, 'Impossible de vous localiser.', icon: Symbols.location_off_rounded);
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _onFilterChanged(ReportStatus? status) {
    setState(() {
      _statusFilter = status;
      // La fiche se ferme si le signalement affiché n'est plus visible.
      if (_selected != null && status != null && _selected!.status != status) {
        _selected = null;
      }
    });
  }

  /// Ouvre le formulaire de signalement ; à son retour, confirme l'envoi.
  Future<void> _openNewReport() async {
    final tracking = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const NewReportPage()),
    );
    if (tracking != null && mounted) {
      _showMessage('Signalement #$tracking envoyé (démonstration)');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDark = context.isDark;

    // Dans Figma, la barre d'état fait 36 px et la recherche commence à y = 40.
    final topInset = MediaQuery.paddingOf(context).top;
    final double searchTop = (topInset < 36 ? 36.0 : topInset) + 4;
    final double filtersTop = searchTop + 52 + 12;

    final sheetVisible = _selected != null;

    final overlay = (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
        .copyWith(statusBarColor: Colors.transparent);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        backgroundColor: c.background,
        body: Stack(
          children: [
            // Carte plein écran.
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: _initialCamera,
                style: isDark ? MapStyles.dark : MapStyles.light,
                markers: _buildMarkers(),
                onMapCreated: (controller) => _mapController = controller,
                onTap: (_) => setState(() => _selected = null),
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
                myLocationEnabled: _showMyLocation,
                myLocationButtonEnabled: false,
              ),
            ),
            // Recherche : 16 des bords, 328 × 52.
            Positioned(
              top: searchTop,
              left: 16,
              right: 16,
              child: MapSearchBar(
                initials: _userInitials,
                onTap: () => _showMessage('Recherche : bientôt disponible'),
              ),
            ),
            // Puces de filtre : 12 px sous la recherche.
            Positioned(
              top: filtersTop,
              left: 16,
              right: 16,
              child: MapFilterChips(
                selected: _statusFilter,
                onChanged: _onFilterChanged,
              ),
            ),
            // Fiche du signalement : 16 des bords, 44 au-dessus de la barre du bas.
            Positioned(
              left: 16,
              right: 16,
              bottom: 44,
              child: IgnorePointer(
                ignoring: !sheetVisible,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  offset: sheetVisible ? Offset.zero : const Offset(0, 1.4),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: sheetVisible ? 1 : 0,
                    child: _sheetReport == null
                        ? const SizedBox.shrink()
                        : ReportSheetCard(
                            report: _sheetReport!,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => ReportDetailPage(report: _sheetReport!),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            // Bouton « Ma position » : 12 px au-dessus du bouton « Signaler »
            // (25 + 48 + 12 = 85 ; avec la fiche ouverte : 184 + 48 + 12 = 244).
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              right: 16,
              bottom: sheetVisible ? 244 : 85,
              child: LocateButton(isLoading: _isLocating, onPressed: _goToMyLocation),
            ),
            // Bouton « Signaler » : 16 du bord droit, 25 au-dessus de la barre ;
            // 20 au-dessus de la fiche quand elle est ouverte (44 + 120 + 20).
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              right: 16,
              bottom: sheetVisible ? 184 : 25,
              child: CityExtendedFab(
                label: 'Signaler',
                icon: Symbols.add_rounded,
                onPressed: _openNewReport,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
