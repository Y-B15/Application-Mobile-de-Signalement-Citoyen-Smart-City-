import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';

/// Bloc « Rayon de proximité » (Figma : padding 16 / 12 / 16 / 14, espace 10) :
/// titre + valeur dans une pastille (« 5 km »), curseur de 1 à 10 km, repères
/// « 1 km » et « 10 km ».
class ProximitySection extends StatelessWidget {
  const ProximitySection({super.key, required this.km, required this.onChanged});

  /// Rayon choisi, de 1 à 10 km.
  final int km;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Symbols.radar_rounded, size: 22, color: c.caption),
              const SizedBox(width: 12),
              Expanded(child: Text('Rayon de proximité', style: AppText.body(c.text))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: c.tint(c.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('$km km', style: AppText.bodyStrong(c.primary)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 24,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 8,
                trackShape: const _FullWidthTrackShape(),
                thumbShape: const _RingThumbShape(),
                overlayShape: SliderComponentShape.noOverlay,
                activeTrackColor: c.primary,
                inactiveTrackColor: c.line,
                thumbColor: c.primary,
                // Pas de repères visibles sur la piste.
                tickMarkShape: SliderTickMarkShape.noTickMark,
                showValueIndicator: ShowValueIndicator.never,
              ),
              child: Slider(
                value: km.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: (v) => onChanged(v.round()),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1 km', style: AppText.caption(c.caption)),
              Text('10 km', style: AppText.caption(c.caption)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Piste de 8 px qui occupe toute la largeur (Figma : 296 px), extrémités arrondies.
class _FullWidthTrackShape extends RoundedRectSliderTrackShape {
  const _FullWidthTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final height = sliderTheme.trackHeight ?? 8;
    final top = offset.dy + (parentBox.size.height - height) / 2;
    return Rect.fromLTWH(offset.dx, top, parentBox.size.width, height);
  }
}

/// Bouton du curseur : disque primaire de 24 px avec un contour blanc de 3 px
/// (Figma : ellipse de 24 px, contour #FFFFFF de 3 px).
class _RingThumbShape extends SliderComponentShape {
  const _RingThumbShape();

  static const double _radius = 12;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(_radius * 2, _radius * 2);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    canvas.drawCircle(center, _radius, Paint()..color = Colors.white);
    canvas.drawCircle(center, _radius - 3, Paint()..color = sliderTheme.thumbColor ?? Colors.teal);
  }
}
