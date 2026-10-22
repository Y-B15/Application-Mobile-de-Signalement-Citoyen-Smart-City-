import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/data/reports_repository.dart';
import '../../core/models/report.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decor.dart';
import '../../shared/widgets/city_extended_fab.dart';
import '../../shared/widgets/report_icons.dart';
import '../new_report/new_report_page.dart';
import 'map_styles.dart';
import 'marker_icon_factory.dart';
import 'widgets/map_filter_chips.dart';
import 'widgets/map_search_bar.dart';
import 'widgets/report_sheet_card.dart';

/// Écran « Carte » (Figma : « 2 · Carte » et « 2.2 · Carte après clic »).
///
/// Une carte Google Maps plein écran avec géolocalisation GPS personnalisée,
/// point de localisation stylisé aux couleurs de l'application (sans grand cercle
/// bleu ni flèche d'orientation), bouton de recentrage positionné juste au-dessus
/// du bouton « Signaler », barre de recherche et puces de filtre.
class MapPage extends StatefulWidget {
  const MapPage({super.key, ReportsRepository? repository})
      : repository = repository ?? const MockReportsRepository();

  final ReportsRepository repository;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  /// Centre par défaut de la carte : Casablanca, zoom 16.
  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(33.5883, -7.6322),
    zoom: 16,
  );

  // Utilisateur de démonstration.
  static const String _userInitials = 'YB';

  GoogleMapController? _mapController;
  List<Report> _reports = const [];
  ReportStatus? _statusFilter; // null = « Tous »
  Report? _selected;
  Report? _sheetReport;

  LatLng? _userLocation;
  BitmapDescriptor? _userIcon;
  bool _hasLocationPermission = false;

  /// Images des repères, une par couple catégorie + statut.
  Map<String, BitmapDescriptor> _icons = const {};
  Brightness? _iconsBrightness;
  double? _iconsRatio;

  @override
  void initState() {
    super.initState();
    _loadReports();
    _requestLocationPermission();
  }

  /// Demande l'autorisation GPS dès l'ouverture de la carte.
  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      if (!mounted) return;
      setState(() => _hasLocationPermission = true);
      _goToUserCurrentLocation();
    }
  }

  /// Anime la caméra vers la position GPS réelle de l'utilisateur.
  Future<void> _goToUserCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!mounted) return;

      final latLng = LatLng(position.latitude, position.longitude);
      setState(() => _userLocation = latLng);

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 15.5),
      );
    } catch (_) {
      if (!mounted) return;
      _showMessage('Impossible de récupérer votre position GPS.');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buildIcons();
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

  /// Dessine le repère de position utilisateur stylisé (point couleur primaire).
  Future<BitmapDescriptor> _buildUserIcon(CityAlertColors c) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(64, 64);
    final center = Offset(size.width / 2, size.height / 2);

    // Ombre douce extérieure
    canvas.drawCircle(
      center,
      22,
      Paint()..color = c.primary.withAlpha(45),
    );

    // Halo extérieur blanc
    canvas.drawCircle(
      center,
      14,
      Paint()..color = Colors.white,
    );

    // Point central aux couleurs primaires de l'application
    canvas.drawCircle(
      center,
      10,
      Paint()..color = c.primary,
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.width.toInt(), size.height.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  /// Dessine les 9 repères aux couleurs du thème et le repère utilisateur.
  Future<void> _buildIcons() async {
    final brightness = Theme.of(context).brightness;
    final ratio = MediaQuery.devicePixelRatioOf(context);
    if (_iconsBrightness == brightness && _iconsRatio == ratio) return;
    _iconsBrightness = brightness;
    _iconsRatio = ratio;

    final colors = brightness == Brightness.dark
        ? CityAlertColors.dark
        : CityAlertColors.light;

    // Icône utilisateur personnalisée aux couleurs de l'application
    final userIcon = await _buildUserIcon(colors);

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
    setState(() {
      _icons = next;
      _userIcon = userIcon;
    });
  }

  static String _iconKey(ReportCategory c, ReportStatus s) => '${c.name}-${s.name}';

  List<Report> get _visibleReports => _statusFilter == null
      ? _reports
      : _reports.where((r) => r.status == _statusFilter).toList();

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    // Repère de localisation utilisateur personnalisé
    if (_userLocation != null && _userIcon != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: _userLocation!,
          icon: _userIcon!,
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    if (_icons.isNotEmpty) {
      for (final r in _visibleReports) {
        if (r.latitude != null && r.longitude != null) {
          markers.add(
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
          );
        }
      }
    }

    return markers;
  }

  void _onFilterChanged(ReportStatus? status) {
    setState(() {
      _statusFilter = status;
      if (_selected != null && status != null && _selected!.status != status) {
        _selected = null;
      }
    });
  }

  /// Ouvre le formulaire de signalement.
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

    final topInset = MediaQuery.paddingOf(context).top;
    final double searchTop = (topInset < 36.0 ? 36.0 : topInset) + 4.0;
    final double filtersTop = searchTop + 52.0 + 12.0;

    final sheetVisible = _selected != null;

    final overlay = (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
        .copyWith(statusBarColor: Colors.transparent);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        backgroundColor: c.background,
        body: Stack(
          children: [
            // Carte plein écran Google Maps avec repères personnalisés
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: _initialCamera,
                style: isDark ? MapStyles.dark : MapStyles.light,
                markers: _buildMarkers(),
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                onMapCreated: (controller) {
                  _mapController = controller;
                  if (_hasLocationPermission) {
                    _goToUserCurrentLocation();
                  }
                },
                onTap: (_) => setState(() => _selected = null),
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
              ),
            ),

            // Barre de recherche
            Positioned(
              top: searchTop,
              left: 16,
              right: 16,
              child: MapSearchBar(
                initials: _userInitials,
                onTap: () => _showMessage('Recherche : bientôt disponible'),
              ),
            ),

            // Puces de filtre
            Positioned(
              top: filtersTop,
              left: 16,
              right: 16,
              child: MapFilterChips(
                selected: _statusFilter,
                onChanged: _onFilterChanged,
              ),
            ),

            // Fiche du signalement sélectionné
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
                            onTap: () => _showMessage(
                              'Détail de #${_sheetReport!.trackingNumber} : bientôt disponible',
                            ),
                          ),
                  ),
                ),
              ),
            ),

            // Bouton de recentrage GPS (placé juste au-dessus du bouton Signaler)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              right: 16,
              bottom: sheetVisible ? 242 : 83,
              child: Material(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                elevation: 2,
                shadowColor: Colors.black26,
                child: InkWell(
                  onTap: _goToUserCurrentLocation,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: Icon(
                        Symbols.my_location_rounded,
                        size: 22,
                        color: c.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bouton « Signaler »
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
