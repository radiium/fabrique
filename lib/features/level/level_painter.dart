import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/tilt.dart';
import '../../core/format.dart';
import '../../core/painting.dart';

/// Inclinaison correspondant au bord de la fiole.
const double _maxAngle = 10;

/// Graduations concentriques, en degrés.
const List<double> _rings = [2.5, 5, 7.5, 10];

/// Bandes réservées aux lectures d'angle (en haut) et à l'état (en bas).
const double _readoutBand = 44;
const double _stateBand = 24;

/// La vedette de l'écran : niveau à bulle dessiné, bulle mobile selon les
/// angles déjà calculés.
///
/// Fiole circulaire plutôt que tubulaire : [TiltResult] porte deux axes, un
/// tube n'en montrerait qu'un et il faudrait deux dessins pour dire la même
/// chose.
///
/// **Convention** : la bulle monte du côté **haut**, comme dans un vrai niveau
/// à bulle — pas comme une bille qui roulerait dans la pente. C'est ce qui rend
/// la lecture transposable à l'outil que le menuisier a déjà en main.
class LevelPainter extends CustomPainter {
  const LevelPainter({required this.result});

  final TiltResult? result;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final r = result;
    if (r == null) {
      drawSchemaPlaceholder(canvas, size);
      return;
    }

    final vialHeight = size.height - _readoutBand - _stateBand;
    final radius = math.min(size.width, vialHeight) / 2 - 6;
    if (radius <= 12) return;

    final center = Offset(size.width / 2, _readoutBand + vialHeight / 2);
    final bubbleRadius = (radius * 0.14).clamp(6.0, 20.0);

    _paintVial(canvas, center, radius, r.isLevel);
    _paintTarget(canvas, center, bubbleRadius, r.isLevel);
    _paintBubble(canvas, center, radius, bubbleRadius, r);
    _paintReadouts(canvas, size, r);
    _paintState(canvas, size, r);
  }

  /// La fiole : fond clair, graduations concentriques, réticule. Son contour
  /// s'épaissit et prend l'accent dès que l'aplomb est atteint — le signal se
  /// voit du coin de l'œil, sans lire le texte.
  void _paintVial(Canvas canvas, Offset center, double radius, bool isLevel) {
    canvas.drawCircle(center, radius, Paint()..color = AppColors.surface);

    final ring = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final crosshair = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    for (final angle in _rings) {
      if (angle >= _maxAngle) continue;
      final ringRadius = radius * angle / _maxAngle;
      canvas.drawCircle(center, ringRadius, ring);
      // Une graduation sur deux est chiffrée : quatre nombres dans une fiole
      // de la taille d'une pièce de monnaie, ce serait illisible.
      if (angle % 5 != 0) continue;
      schemaText(
        '${formatDegrees(angle)}°',
        size: 9,
      ).paint(canvas, Offset(center.dx + ringRadius + 3, center.dy - 12));
    }

    canvas
      ..drawLine(
        Offset(center.dx - radius, center.dy),
        Offset(center.dx + radius, center.dy),
        crosshair,
      )
      ..drawLine(
        Offset(center.dx, center.dy - radius),
        Offset(center.dx, center.dy + radius),
        crosshair,
      )
      ..drawCircle(
        center,
        radius,
        Paint()
          ..color = isLevel ? AppColors.accent : AppColors.label
          ..style = PaintingStyle.stroke
          ..strokeWidth = isLevel ? 3 : 1.5,
      );
  }

  /// La cible centrale : la zone où la bulle doit tomber pour être d'aplomb.
  void _paintTarget(
    Canvas canvas,
    Offset center,
    double bubbleRadius,
    bool isLevel,
  ) {
    canvas.drawCircle(
      center,
      bubbleRadius + 4,
      Paint()
        ..color = isLevel ? AppColors.accent : AppColors.label
        ..style = PaintingStyle.stroke
        ..strokeWidth = isLevel ? 2 : 1,
    );
  }

  void _paintBubble(
    Canvas canvas,
    Offset center,
    double radius,
    double bubbleRadius,
    TiltResult r,
  ) {
    // La bulle va du côté haut : incliner la droite vers le bas la renvoie à
    // gauche. D'où le signe inversé sur le roulis.
    final travel = radius - bubbleRadius - 2;
    final raw = Offset(-r.rollDeg / _maxAngle, r.pitchDeg / _maxAngle) * travel;

    // Bridage d'affichage, pas un calcul : au-delà de la plage de la fiole la
    // bulle se colle au bord plutôt que de sortir du dessin.
    final offset = raw.distance > travel && raw.distance > 0
        ? raw * (travel / raw.distance)
        : raw;
    final bubble = center + offset;

    canvas
      ..drawCircle(bubble, bubbleRadius, Paint()..color = AppColors.accent)
      ..drawCircle(
        bubble,
        bubbleRadius,
        Paint()
          ..color = AppColors.surface
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
  }

  /// Les deux inclinaisons, en gros, au-dessus de la fiole. Les flèches disent
  /// quel axe est lu — un libellé de plus n'apprendrait rien de mieux, et le
  /// dessin les explique déjà.
  void _paintReadouts(Canvas canvas, Size size, TiltResult r) {
    final readouts = [('↔', r.rollDeg), ('↕', r.pitchDeg)];

    for (final (i, (glyph, value)) in readouts.indexed) {
      final text = schemaText(
        '$glyph ${formatDegrees(value)}°',
        size: 22,
        color: AppColors.accentDeep,
        weight: FontWeight.w700,
      );
      // Deux colonnes de largeur égale, chacune centrée sur sa moitié.
      final columnCenter = size.width * (i == 0 ? 0.28 : 0.72);
      text.paint(
        canvas,
        Offset(columnCenter - text.width / 2, (_readoutBand - text.height) / 2),
      );
    }
  }

  void _paintState(Canvas canvas, Size size, TiltResult r) {
    final text = schemaText(
      r.isLevel ? 'À plat' : 'Hors niveau',
      size: 13,
      color: r.isLevel ? AppColors.accent : AppColors.label,
      weight: r.isLevel ? FontWeight.w700 : FontWeight.w600,
    );
    text.paint(
      canvas,
      Offset(
        (size.width - text.width) / 2,
        size.height - _stateBand + (_stateBand - text.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(LevelPainter old) => old.result != result;
}
