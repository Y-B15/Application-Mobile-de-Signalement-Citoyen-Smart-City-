import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../shared/widgets/city_toast.dart';

/// Couleurs fixes de l'écran « Prise de photo » : identiques en clair et en
/// sombre dans Figma (interface d'appareil photo toujours sombre).
abstract final class _CameraColors {
  static const Color background = Color(0xFF0B0D10);
  static const Color viewfinder = Color(0xFF1B2128);
  static const Color white = Color(0xFFFFFFFF);
  static const Color glass14 = Color(0x24FFFFFF); // blanc à 14 %
  static const Color glass16 = Color(0x29FFFFFF); // blanc à 16 %
  static const Color hintBackground = Color(0x8C000000); // noir à 55 %
}

/// Écran « Prise de photo » (Figma : « Prise de photo ») : viseur de 328 × 470
/// avec cadre et grille, éclair et galerie en haut, déclencheur au centre bas.
///
/// Se ferme en renvoyant le chemin de la photo (appareil photo ou galerie),
/// ou `null` si l'utilisateur annule.
class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  final ImagePicker _picker = ImagePicker();

  List<CameraDescription> _cameras = const [];
  CameraController? _controller;
  int _cameraIndex = 0;

  bool _flashOn = false;
  double _zoom = 1;
  double _minZoom = 1;
  double _maxZoom = 1;

  bool _isStarting = false;
  bool _isCapturing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  /// Libère la caméra quand l'application passe en arrière-plan (ou pendant la
  /// fenêtre de permission), puis la relance au retour.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      final c = _controller;
      if (c != null) {
        setState(() => _controller = null);
        c.dispose();
      }
    } else if (state == AppLifecycleState.resumed &&
        _controller == null &&
        _cameras.isNotEmpty &&
        _error == null) {
      _startCamera();
    }
  }

  Future<void> _init() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _fail('Aucune caméra disponible sur cet appareil.');
        return;
      }
      _cameras = cameras;
      final back = cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.back);
      _cameraIndex = back >= 0 ? back : 0;
      await _startCamera();
    } on CameraException catch (e) {
      _fail(_messageFor(e));
    } catch (_) {
      _fail('Caméra indisponible.');
    }
  }

  Future<void> _startCamera() async {
    if (_isStarting) return;
    _isStarting = true;

    final old = _controller;
    if (old != null) {
      setState(() => _controller = null);
      await old.dispose();
    }

    final controller = CameraController(
      _cameras[_cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await controller.initialize();
      final minZoom = await controller.getMinZoomLevel();
      final maxZoom = await controller.getMaxZoomLevel();
      await controller.setFlashMode(_flashOn ? FlashMode.always : FlashMode.off);
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _minZoom = minZoom;
        _maxZoom = maxZoom;
        _zoom = 1.0.clamp(minZoom, maxZoom).toDouble();
        _error = null;
      });
    } on CameraException catch (e) {
      await controller.dispose();
      _fail(_messageFor(e));
    } finally {
      _isStarting = false;
    }
  }

  String _messageFor(CameraException e) {
    if (e.code.startsWith('CameraAccess')) {
      return 'Autorisez l’accès à la caméra pour prendre une photo.';
    }
    return 'Caméra indisponible.';
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() => _error = message);
  }

  /// Message temporaire (style « toast » de Figma).
  void _toast(String message, {IconData? icon}) {
    if (!mounted) return;
    CityToast.show(context, message, icon: icon);
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) return;

    setState(() => _isCapturing = true);
    try {
      final file = await controller.takePicture();
      if (!mounted) return;
      Navigator.of(context).pop(file.path);
    } on CameraException {
      if (!mounted) return;
      setState(() => _isCapturing = false);
      _toast('Photo impossible, réessayez.');
    }
  }

  Future<void> _toggleFlash() async {
    final next = !_flashOn;
    setState(() => _flashOn = next);
    try {
      await _controller?.setFlashMode(next ? FlashMode.always : FlashMode.off);
      if (next) _toast('Flash activé', icon: Symbols.flash_on_rounded);
    } on CameraException {
      _toast('Flash indisponible sur cette caméra.');
    }
  }

  /// Bascule entre 1× et 2× (si la caméra le permet).
  Future<void> _toggleZoom() async {
    final controller = _controller;
    if (controller == null) return;
    final next = (_zoom < 1.5 && _maxZoom >= 2) ? 2.0 : 1.0;
    final clamped = next.clamp(_minZoom, _maxZoom).toDouble();
    try {
      await controller.setZoomLevel(clamped);
      if (mounted) setState(() => _zoom = clamped);
    } on CameraException {
      _toast('Zoom indisponible.');
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2) {
      _toast('Une seule caméra sur cet appareil.');
      return;
    }
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _startCamera();
    _toast('Caméra retournée', icon: Symbols.flip_camera_android_rounded);
  }

  Future<void> _openGallery() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        imageQuality: 85,
      );
      if (file != null && mounted) Navigator.of(context).pop(file.path);
    } catch (_) {
      _toast('Impossible d’ouvrir la galerie.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _CameraColors.background,
      ),
      child: Scaffold(
        backgroundColor: _CameraColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Éclair (gauche) et galerie (droite) : boutons de 44 px.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _GlassButton(
                      size: 44,
                      icon: _flashOn ? Symbols.flash_on_rounded : Symbols.flash_off_rounded,
                      label: _flashOn ? 'Désactiver le flash' : 'Activer le flash',
                      onTap: _toggleFlash,
                    ),
                    _GlassButton(
                      size: 44,
                      icon: Symbols.photo_library_rounded,
                      label: 'Galerie',
                      onTap: _openGallery,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 470),
                            child: SizedBox.expand(child: _buildViewfinder()),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildControls(),
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

  /// Viseur : aperçu de la caméra, grille des tiers, cadre blanc et conseil.
  Widget _buildViewfinder() {
    final controller = _controller;

    Widget content;
    if (_error != null) {
      content = _ErrorMessage(
        message: _error!,
        onRetry: () {
          setState(() => _error = null);
          _init();
        },
      );
    } else if (controller != null && controller.value.isInitialized) {
      // L'aperçu est en paysage : on échange largeur et hauteur puis on
      // « remplit » le viseur (cover).
      final size = controller.value.previewSize!;
      content = FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: size.height,
          height: size.width,
          child: CameraPreview(controller),
        ),
      );
    } else {
      content = const Center(
        child: CircularProgressIndicator(color: _CameraColors.white, strokeWidth: 2),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ColoredBox(
        color: _CameraColors.viewfinder,
        child: Stack(
          fit: StackFit.expand,
          children: [
            content,
            const IgnorePointer(child: CustomPaint(painter: _FramePainter())),
            // Conseil : 24 px sous le haut, centré (Figma : « Hint »).
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _CameraColors.hintBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Symbols.center_focus_strong_rounded,
                        size: 18,
                        color: _CameraColors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Cadrez le problème',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 16 / 13,
                          color: _CameraColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Zoom 1×, puis fermer / déclencheur / retourner la caméra.
  Widget _buildControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: _CameraColors.glass16,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _toggleZoom,
            child: SizedBox(
              width: 40,
              height: 28,
              child: Center(
                child: Text(
                  '${_zoom.round()}×',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 16 / 12,
                    color: _CameraColors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _GlassButton(
                size: 48,
                icon: Symbols.close_rounded,
                label: 'Fermer',
                onTap: () => Navigator.of(context).pop(),
              ),
              _ShutterButton(isBusy: _isCapturing, onTap: _capture),
              _GlassButton(
                size: 48,
                icon: Symbols.flip_camera_android_rounded,
                label: 'Retourner la caméra',
                onTap: _flipCamera,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Bouton rond translucide (blanc à 14 %) avec une icône blanche de 24 px.
class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.size,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final double size;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: _CameraColors.glass14,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, size: 24, color: _CameraColors.white),
          ),
        ),
      ),
    );
  }
}

/// Déclencheur 80 × 80 : anneau blanc de 4 px et disque blanc de 62 px.
class _ShutterButton extends StatelessWidget {
  const _ShutterButton({required this.isBusy, required this.onTap});

  final bool isBusy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Prendre la photo',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: isBusy ? 0.92 : 1,
          duration: const Duration(milliseconds: 120),
          child: Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _CameraColors.white, width: 4),
            ),
            child: Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(
                color: _CameraColors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Grille des tiers (traits de 1 px, blanc à 16 %) et quatre coins blancs
/// (28 × 4, rayon 2, à 16 px du bord).
class _FramePainter extends CustomPainter {
  const _FramePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = _CameraColors.glass16;
    final w = size.width;
    final h = size.height;

    canvas.drawRect(Rect.fromLTWH(w / 3, 0, 1, h), grid);
    canvas.drawRect(Rect.fromLTWH(w * 2 / 3, 0, 1, h), grid);
    canvas.drawRect(Rect.fromLTWH(0, h / 3, w, 1), grid);
    canvas.drawRect(Rect.fromLTWH(0, h * 2 / 3, w, 1), grid);

    final white = Paint()..color = _CameraColors.white;
    void bar(double l, double t, double bw, double bh) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(l, t, bw, bh), const Radius.circular(2)),
        white,
      );
    }

    const inset = 16.0, len = 28.0, thick = 4.0;
    // Haut gauche, haut droite, bas gauche, bas droite.
    bar(inset, inset, len, thick);
    bar(inset, inset, thick, len);
    bar(w - inset - len, inset, len, thick);
    bar(w - inset - thick, inset, thick, len);
    bar(inset, h - inset - thick, len, thick);
    bar(inset, h - inset - len, thick, len);
    bar(w - inset - len, h - inset - thick, len, thick);
    bar(w - inset - thick, h - inset - len, thick, len);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Message affiché dans le viseur quand la caméra n'est pas disponible.
class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Symbols.no_photography_rounded, size: 32, color: _CameraColors.white),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 20 / 14,
                color: _CameraColors.white,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Réessayer',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _CameraColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
