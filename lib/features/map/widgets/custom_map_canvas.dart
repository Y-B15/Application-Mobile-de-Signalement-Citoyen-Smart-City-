import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/models/report.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decor.dart';

/// Composant de carte vectorielle interactive personnalisée.
///
/// Sert de vue de carte fluide, ultra-rapide et garantie sans écran blanc,
/// indépendante de la présence d'une clé API Google Maps.
/// Affiche la grille urbaine, le littoral, la position GPS réelle de l'utilisateur
/// et les marqueurs de signalements interactifs.
class CustomMapCanvas extends StatefulWidget {
  const CustomMapCanvas({
    super.key,
    required this.centerLat,
    required this.centerLng,
    required this.reports,
    required this.selectedReport,
    required this.onReportSelected,
    this.userPosition,
  });

  final double centerLat;
  final double centerLng;
  final List<Report> reports;
  final Report? selectedReport;
  final ValueChanged<Report> onReportSelected;
  final Position? userPosition;

  @override
  State<CustomMapCanvas> createState() => _CustomMapCanvasState();
}

class _CustomMapCanvasState extends State<CustomMapCanvas> {
  double _zoom = 1.0;
  Offset _panOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDark = context.isDark;

    return GestureDetector(
      onScaleUpdate: (details) {
        setState(() {
          _zoom = (_zoom * details.scale).clamp(0.6, 2.5);
          _panOffset += details.focalPointDelta;
        });
      },
      child: Stack(
        children: [
          // Dessin du fond de carte (routes, mer, îlots urbains)
          CustomPaint(
            size: Size.infinite,
            painter: _MapGridPainter(
              colors: c,
              isDark: isDark,
              panOffset: _panOffset,
              zoom: _zoom,
            ),
          ),

          // Marqueurs de signalements sur la carte
          LayoutBuilder(
            builder: (context, constraints) {
              final center = Offset(
                constraints.maxWidth / 2 + _panOffset.dx,
                constraints.maxHeight / 2 + _panOffset.dy,
              );

              return Stack(
                children: [
                  // Position GPS en temps réel de l'utilisateur
                  if (widget.userPosition != null)
                    _buildUserGpsMarker(
                      context,
                      center,
                      widget.userPosition!,
                    ),

                  // Pins des signalements
                  for (final report in widget.reports)
                    if (report.latitude != null && report.longitude != null)
                      _buildReportMarker(
                        context,
                        center,
                        report,
                      ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Calcule l'emplacement à l'écran en fonction des coordonnées GPS.
  Offset _gpsToScreen(Offset screenCenter, double lat, double lng) {
    // Échelle de conversion GPS -> Pixels (~111 km par degré de lat)
    const scale = 12000.0;
    final dy = (widget.centerLat - lat) * scale * _zoom;
    final dx = (lng - widget.centerLng) * scale * _zoom;

    return Offset(screenCenter.dx + dx, screenCenter.dy + dy);
  }

  /// Repère GPS utilisateur (Point bleu + cercle de précision animé)
  Widget _buildUserGpsMarker(
    BuildContext context,
    Offset screenCenter,
    Position pos,
  ) {
    final posOffset = _gpsToScreen(screenCenter, pos.latitude, pos.longitude);
    final c = context.colors;

    return Positioned(
      left: posOffset.dx - 24,
      top: posOffset.dy - 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.primary.withAlpha(40),
            ),
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c.primary,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: AppShadows.elevation1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Marqueur interactif d'un signalement
  Widget _buildReportMarker(
    BuildContext context,
    Offset screenCenter,
    Report report,
  ) {
    final posOffset = _gpsToScreen(
      screenCenter,
      report.latitude!,
      report.longitude!,
    );
    final c = context.colors;
    final isSelected = widget.selectedReport?.id == report.id;
    final statusColor = c.statusColor(report.status);

    return Positioned(
      left: posOffset.dx - (isSelected ? 24 : 18),
      top: posOffset.dy - (isSelected ? 48 : 36),
      child: GestureDetector(
        onTap: () => widget.onReportSelected(report),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: isSelected ? 48 : 36,
          height: isSelected ? 48 : 36,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: isSelected ? 3.5 : 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isSelected ? 80 : 40),
                blurRadius: isSelected ? 8 : 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            _categoryIcon(report.category),
            size: isSelected ? 24 : 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static IconData _categoryIcon(ReportCategory category) => switch (category) {
        ReportCategory.pothole => Symbols.construction_rounded,
        ReportCategory.streetLight => Symbols.lightbulb_rounded,
        ReportCategory.illegalDump => Symbols.delete_rounded,
      };
}

/// Peintre du fond de carte vectorielle (Grille de rue + Littéral).
class _MapGridPainter extends CustomPainter {
  _MapGridPainter({
    required this.colors,
    required this.isDark,
    required this.panOffset,
    required this.zoom,
  });

  final CityAlertColors colors;
  final bool isDark;
  final Offset panOffset;
  final double zoom;

  @override
  void paint(Canvas canvas, Size size) {
    // Fond de carte
    final bgPaint = Paint()..color = isDark ? const Color(0xFF181C22) : const Color(0xFFF1F5F9);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Dessin de l'Océan (Zone d'eau supérieure pour Casablanca)
    final seaPaint = Paint()..color = isDark ? const Color(0xFF11161D) : const Color(0xFFE2E8F0);
    final seaPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.22 + panOffset.dy * 0.2)
      ..quadraticBezierTo(
        size.width * 0.5 + panOffset.dx * 0.2,
        size.height * 0.18 + panOffset.dy * 0.2,
        0,
        size.height * 0.25 + panOffset.dy * 0.2,
      )
      ..close();
    canvas.drawPath(seaPath, seaPaint);

    // Grille de rues urbaines
    final roadPaint = Paint()
      ..color = isDark ? const Color(0xFF262D38) : const Color(0xFFE2E8F0)
      ..strokeWidth = 3.0 * zoom
      ..style = PaintingStyle.stroke;

    final mainRoadPaint = Paint()
      ..color = isDark ? const Color(0xFF333D4C) : const Color(0xFFCBD5E1)
      ..strokeWidth = 6.0 * zoom
      ..style = PaintingStyle.stroke;

    final step = 80.0 * zoom;
    final startX = (panOffset.dx % step) - step;
    final startY = (panOffset.dy % step) - step;

    // Rues secondaires
    for (double x = startX; x < size.width + step; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), roadPaint);
    }
    for (double y = startY; y < size.height + step; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roadPaint);
    }

    // Boulevards principaux
    final center = Offset(size.width / 2 + panOffset.dx, size.height / 2 + panOffset.dy);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), mainRoadPaint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), mainRoadPaint);
    canvas.drawLine(
      Offset(center.dx - 300, center.dy - 300),
      Offset(center.dx + 300, center.dy + 300),
      mainRoadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) {
    return oldDelegate.panOffset != panOffset ||
        oldDelegate.zoom != zoom ||
        oldDelegate.isDark != isDark;
  }
}
