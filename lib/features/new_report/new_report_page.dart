import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/data/reports_repository.dart';
import '../../core/models/new_report.dart';
import '../../core/models/report.dart';
import '../../core/services/location_service.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/city_app_bar.dart';
import '../../shared/widgets/city_button.dart';
import '../camera/camera_page.dart';
import 'widgets/category_section.dart';
import 'widgets/description_field.dart';
import 'widgets/location_section.dart';
import 'widgets/photo_section.dart';

/// Écran « Nouveau signalement » (Figma : « 3 · Nouveau signalement »).
///
/// Marges 16 (gauche/droite) et 8 (haut/bas), espace de 12 entre les sections :
/// photo, localisation, catégorie, description, bouton d'envoi.
///
/// Se ferme en renvoyant le numéro de suivi (« CA-2050 ») quand l'envoi réussit.
class NewReportPage extends StatefulWidget {
  const NewReportPage({
    super.key,
    ReportsRepository? repository,
    this.locationService = const LocationService(),
  }) : repository = repository ?? const MockReportsRepository();

  final ReportsRepository repository;
  final LocationService locationService;

  @override
  State<NewReportPage> createState() => _NewReportPageState();
}

class _NewReportPageState extends State<NewReportPage> {
  final TextEditingController _description = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  ReportCategory _category = ReportCategory.pothole; // choisie par défaut (Figma)
  String? _photoPath;

  PlaceInfo? _place;
  bool _isLocating = true;
  String? _locationError;

  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _locate();
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  /// Demande la position GPS (et l'adresse correspondante).
  Future<void> _locate() async {
    setState(() {
      _isLocating = true;
      _locationError = null;
    });
    try {
      final place = await widget.locationService.currentPlace();
      if (!mounted) return;
      setState(() {
        _place = place;
        _isLocating = false;
      });
    } on LocationException catch (e) {
      if (!mounted) return;
      setState(() {
        _place = null;
        _isLocating = false;
        _locationError = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _place = null;
        _isLocating = false;
        _locationError = 'Impossible de trouver votre position.';
      });
    }
  }

  /// Ouvre l'appareil photo ; la page renvoie le chemin de la photo prise.
  Future<void> _takePhoto() async {
    final path = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const CameraPage(),
      ),
    );
    if (path != null && mounted) setState(() => _photoPath = path);
  }

  Future<void> _pickFromGallery() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        imageQuality: 85,
      );
      if (file != null && mounted) setState(() => _photoPath = file.path);
    } catch (_) {
      _showMessage('Impossible d’ouvrir la galerie.');
    }
  }

  Future<void> _submit() async {
    final place = _place;
    if (place == null) {
      _showMessage('Position introuvable : activez le GPS puis réessayez.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSending = true);
    try {
      final tracking = await widget.repository.submitReport(
        NewReport(
          category: _category,
          description: _description.text.trim(),
          latitude: place.latitude,
          longitude: place.longitude,
          address: place.address,
          photoPath: _photoPath,
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop(tracking);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSending = false);
      _showMessage('Envoi impossible : vérifiez votre connexion.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final overlay = (context.isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark)
        .copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: c.background,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            // Toucher en dehors d'un champ ferme le clavier.
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                const CityAppBar(title: 'Nouveau signalement'),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PhotoSection(
                          photoPath: _photoPath,
                          onCamera: _takePhoto,
                          onGallery: _pickFromGallery,
                        ),
                        const SizedBox(height: 12),
                        LocationSection(
                          place: _place,
                          isLoading: _isLocating,
                          errorMessage: _locationError,
                          onEdit: () => _showMessage(
                            'Modifier la position : bientôt disponible',
                          ),
                          onRetry: _locate,
                        ),
                        const SizedBox(height: 12),
                        CategorySection(
                          selected: _category,
                          onChanged: (value) => setState(() => _category = value),
                        ),
                        const SizedBox(height: 12),
                        DescriptionField(controller: _description),
                        const SizedBox(height: 12),
                        CityButton(
                          label: 'Envoyer le signalement',
                          isLoading: _isSending,
                          onPressed: _submit,
                        ),
                      ],
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
