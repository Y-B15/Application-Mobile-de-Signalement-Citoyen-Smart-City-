import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Dessine les repères de la carte (Figma : « Pin/… », cadre de 40 × 44) :
/// une goutte à fond de surface, contour de 3 px de la couleur du statut, et
/// l'icône de la catégorie (24 px) de la même couleur au centre.
///
/// Google Maps n'accepte que des images pour ses repères : on dessine donc la
/// goutte avec un `Canvas`, puis on la convertit en PNG.
abstract final class MarkerIconFactory {
  static const double width = 40;
  static const double height = 44;

  /// Point d'ancrage (la pointe de la goutte) en proportion de l'image :
  /// milieu horizontal, y = 42 / 44.
  static const Offset anchor = Offset(0.5, 42 / 44);

  static Future<BitmapDescriptor> pin({
    required IconData icon,
    required Color color,
    required Color fill,
    required double pixelRatio,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(pixelRatio);

    // Goutte de 36 × 40 placée en (2, 2) : tracé relevé dans Figma.
    canvas.save();
    canvas.translate(2, 2);
    final path = Path()
      ..moveTo(18, 40)
      ..cubicTo(14, 35, 0, 26, 0, 18)
      ..cubicTo(0, 13.226, 1.896, 8.648, 5.272, 5.272)
      ..cubicTo(8.648, 1.896, 13.226, 0, 18, 0)
      ..cubicTo(22.774, 0, 27.352, 1.896, 30.728, 5.272)
      ..cubicTo(34.104, 8.648, 36, 13.226, 36, 18)
      ..cubicTo(36, 26, 22, 35, 18, 40)
      ..close();
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.restore();

    // Icône de 24 px en (8, 7), dessinée avec la police Material Symbols.
    final painter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 24,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      Offset(8 + (24 - painter.width) / 2, 7 + (24 - painter.height) / 2),
    );

    final image = await recorder.endRecording().toImage(
          (width * pixelRatio).ceil(),
          (height * pixelRatio).ceil(),
        );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(
      data!.buffer.asUint8List(),
      imagePixelRatio: pixelRatio,
    );
  }
}
