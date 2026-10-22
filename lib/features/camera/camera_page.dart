import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Couleurs fixes de l'écran « Prise de photo ».
abstract final class _CameraColors {
  static const Color background = Color(0xFF0B0D10);
  static const Color viewfinder = Color(0xFF1B2128);
  static const Color white = Color(0xFFFFFFFF);
  static const Color glass14 = Color(0x24FFFFFF);
  static const Color hintBackground = Color(0x8C000000);
}

/// Écran « Prise de photo » (Figma : « Prise de photo »).
///
/// Utilise le capteur photo natif du smartphone (`image_picker`) pour une
/// compatibilité 100 % garantie avec Android (ex: Redmi Note 9S) et iOS.
class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImagePicker _picker = ImagePicker();
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    // Lance la capture natif au chargement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _takePhoto();
    });
  }

  /// Ouvre l'appareil photo natif.
  Future<void> _takePhoto() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2048,
        imageQuality: 85,
      );

      if (!mounted) return;
      if (file != null) {
        Navigator.of(context).pop(file.path);
      } else {
        setState(() => _isCapturing = false);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isCapturing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d’ouvrir l’appareil photo.')),
      );
    }
  }

  /// Ouvre la galerie photo.
  Future<void> _openGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        imageQuality: 85,
      );

      if (!mounted) return;
      if (file != null) {
        Navigator.of(context).pop(file.path);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d’ouvrir la galerie.')),
      );
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
              // En-tête : Fermer et Galerie
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _GlassButton(
                      size: 44,
                      icon: Symbols.close_rounded,
                      label: 'Fermer',
                      onTap: () => Navigator.of(context).pop(),
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

              // Viseur central
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 470),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                color: _CameraColors.viewfinder,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    const Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Symbols.photo_camera_rounded,
                                            size: 64,
                                            color: _CameraColors.white,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Prise de photo...',
                                            style: TextStyle(color: _CameraColors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const IgnorePointer(
                                      child: CustomPaint(painter: _FramePainter()),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 24),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
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
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Boutons d'actions bas : Déclencheur
                      _ShutterButton(
                        isBusy: _isCapturing,
                        onTap: _takePhoto,
                      ),
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
    return Material(
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
    );
  }
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({required this.isBusy, required this.onTap});

  final bool isBusy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}

class _FramePainter extends CustomPainter {
  const _FramePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = _CameraColors.white;
    void bar(double l, double t, double bw, double bh) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(l, t, bw, bh), const Radius.circular(2)),
        white,
      );
    }

    const inset = 16.0, len = 28.0, thick = 4.0;
    final w = size.width;
    final h = size.height;

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
