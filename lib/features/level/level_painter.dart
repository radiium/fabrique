import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/tilt.dart';
import '../../core/painting.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/numbers.dart';

/// Graduations du tube, en degrés : la bulle y tient tout entière sous cet
/// angle.
const List<double> _graduations = [1, 2, 5];

/// Bandes réservées aux lectures d'angle (en haut) et à l'état (en bas).
const double _readoutBand = 44;
const double _stateBand = 24;

/// Hauteur du tube, en fraction du côté du dessin.
const double _tubeHeightRatio = 0.18;

/// Téléphone dessiné à plat, couché sur sa tranche : largeur en fraction du
/// côté du dessin, et rapport hauteur / largeur.
const double _phoneWidthRatio = 0.5;
const double _phoneAspect = 0.48;

/// Demi-longueur du sol sous le téléphone dessiné, en fraction du côté.
const double _groundHalfRatio = 0.4;

/// Hauteur du tube bornée, en px : lisible en vignette, pas envahissant en
/// plein écran.
const double _minTubeHeight = 20;
const double _maxTubeHeight = 48;

/// Niveau à bulle en tube, téléphone sur une tranche. À plat, une consigne.
///
/// Le dessin tourne d'un quart de tour pour rester lisible dans le sens du
/// monde, l'écran étant verrouillé en portrait.
class LevelPainter extends CustomPainter {
  const LevelPainter({required this.result, required this.l10n});

  final TiltResult? result;

  final AppLocalizations l10n;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    switch (result) {
      case null:
        drawSchemaPlaceholder(canvas, size);
      case FlatTilt():
        _paintHint(canvas, size);
      case final EdgeTilt edge:
        _paintEdge(canvas, size, edge);
    }
  }

  /// À plat : un téléphone couché sur sa grande tranche, et la consigne.
  void _paintHint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height);
    final phoneWidth = side * _phoneWidthRatio;
    final phoneHeight = phoneWidth * _phoneAspect;
    if (phoneHeight < 12) return;

    final center = size.center(Offset.zero);
    final groundY = center.dy + phoneHeight / 2;
    final stroke = Paint()
      ..color = AppColors.label
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center,
            width: phoneWidth,
            height: phoneHeight,
          ),
          Radius.circular(phoneHeight * 0.15),
        ),
        stroke,
      )
      ..drawLine(
        Offset(center.dx - side * _groundHalfRatio, groundY),
        Offset(center.dx + side * _groundHalfRatio, groundY),
        stroke,
      );

    final text = schemaText(l10n.levelPlaceOnEdge, size: 13)
      ..textAlign = TextAlign.center
      ..layout(maxWidth: side - 16);
    text.paint(
      canvas,
      Offset(center.dx - text.width / 2, groundY + AppSpacing.md),
    );
  }

  void _paintEdge(Canvas canvas, Size size, EdgeTilt r) {
    final side = math.min(size.width, size.height);
    final tubeHeight = (side * _tubeHeightRatio).clamp(
      _minTubeHeight,
      _maxTubeHeight,
    );
    final tubeWidth = side - 24;
    final bubbleRadius = tubeHeight / 2 - 3;
    final travel = tubeWidth / 2 - bubbleRadius - 2;
    if (travel <= 12 || side < _readoutBand + _stateBand + tubeHeight) return;

    final center = size.center(Offset.zero);
    final frame = Size.square(side);

    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..rotate(r.quarterTurns * math.pi / 2)
      ..translate(-side / 2, -side / 2);

    final tubeCenter = frame.center(Offset.zero);
    final tube = RRect.fromRectAndRadius(
      Rect.fromCenter(center: tubeCenter, width: tubeWidth, height: tubeHeight),
      Radius.circular(tubeHeight / 2),
    );
    canvas
      ..drawRRect(tube, Paint()..color = AppColors.field)
      ..drawRRect(tube, _outline(r.isLevel, 3, 1.5));

    final tick = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    for (final angle in _graduations) {
      for (final sign in const [-1, 1]) {
        final x =
            tubeCenter.dx + sign * (bubbleRadius + travel * vialCourse(angle));
        canvas.drawLine(
          Offset(x, tubeCenter.dy + tubeHeight / 2 - 6),
          Offset(x, tubeCenter.dy + tubeHeight / 2),
          tick,
        );
      }
    }

    // Bulle entre les deux repères, et seulement alors : de niveau.
    final target = bubbleRadius + travel * vialCourse(kLevelThresholdDeg);
    final mark = _outline(r.isLevel, 2, 1);
    for (final sign in const [-1, 1]) {
      final x = tubeCenter.dx + sign * target;
      canvas.drawLine(
        Offset(x, tubeCenter.dy - tubeHeight / 2),
        Offset(x, tubeCenter.dy + tubeHeight / 2),
        mark,
      );
    }

    _paintBubble(
      canvas,
      tubeCenter + Offset(vialCourse(r.angleDeg) * travel, 0),
      bubbleRadius,
    );

    final text = _readout('${l10n.degrees(r.angleDeg)}°');
    text.paint(
      canvas,
      Offset((side - text.width) / 2, (_readoutBand - text.height) / 2),
    );

    // Debout, la grande tranche est verticale : c'est l'aplomb qui se lit.
    final isUpright = r.quarterTurns.isEven;
    _paintState(canvas, frame, switch ((isUpright, r.isLevel)) {
      (true, true) => l10n.levelPlumb,
      (true, false) => l10n.levelOffPlumb,
      (false, true) => l10n.levelOnLevel,
      (false, false) => l10n.levelOff,
    }, isLevel: r.isLevel);

    canvas.restore();
  }

  /// Contour qui prend l'accent et s'épaissit à niveau : le signal se voit du
  /// coin de l'œil.
  Paint _outline(bool isLevel, double levelWidth, double offWidth) => Paint()
    ..color = isLevel ? AppColors.accent : AppColors.label
    ..style = PaintingStyle.stroke
    ..strokeWidth = isLevel ? levelWidth : offWidth;

  void _paintBubble(Canvas canvas, Offset at, double radius) {
    canvas
      ..drawCircle(at, radius, Paint()..color = AppColors.accent)
      ..drawCircle(
        at,
        radius,
        Paint()
          ..color = AppColors.surface
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
  }

  TextPainter _readout(String text) => schemaText(
    text,
    size: 22,
    color: AppColors.accentDeep,
    weight: FontWeight.w700,
  );

  void _paintState(
    Canvas canvas,
    Size size,
    String label, {
    required bool isLevel,
  }) {
    final text = schemaText(
      label,
      size: 13,
      color: isLevel ? AppColors.accent : AppColors.label,
      weight: isLevel ? FontWeight.w700 : FontWeight.w600,
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
  bool shouldRepaint(LevelPainter old) =>
      old.result != result || old.l10n.localeName != l10n.localeName;
}
