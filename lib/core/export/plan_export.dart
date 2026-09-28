/// Sortie d'un plan : le PNG, et la remise au système.
///
/// Le PNG seul : il s'ouvre, s'affiche et s'imprime partout.
library;

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../models/tool.dart';
import 'plan.dart';
import 'plan_download.dart';

/// Largeur du PNG : une A4 à l'italienne à 200 dpi (297 mm).
///
/// À 150 dpi, le corps 8,5 du cartouche tomberait à 25 px, mal lisible
/// imprimé.
const int kPlanPixelWidth = 2339;

/// Rend le plan en PNG, hors de l'arbre de widgets : la définition ne dépend
/// pas de l'écran de l'appareil.
Future<Uint8List> renderPlanPng(
  PlanPainter painter, {
  int width = kPlanPixelWidth,
}) async {
  final height = (width / kPlanAspectRatio).round();
  final size = Size(width.toDouble(), height.toDouble());

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, Offset.zero & size);
  canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.cardSurface);
  painter.paint(canvas, size);

  final picture = recorder.endRecording();
  try {
    final image = await picture.toImage(width, height);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) throw StateError('encodage PNG vide');
      return data.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  } finally {
    picture.dispose();
  }
}

/// `fabrique-distribution-2026-09-23.png` : l'outil et la date, pour s'y
/// retrouver dans un dossier de chantier.
String planFileName(Tool tool, DateTime date) {
  String two(int v) => v.toString().padLeft(2, '0');
  return 'fabrique-${tool.id}-${date.year}-${two(date.month)}-'
      '${two(date.day)}.png';
}

/// Rend le plan et le garde : dans les photos sur mobile, dans les
/// téléchargements sur le web. Rend `true` si l'image est enregistrée.
///
/// Le partage Android n'offre pas d'action « enregistrer ». Sans album ni
/// droit de lecture des photos.
Future<bool> savePlan(
  BuildContext context, {
  required PlanPainter painter,
  required Tool tool,
  required DateTime date,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final l10n = AppLocalizations.of(context);
  final name = planFileName(tool, date);

  try {
    final bytes = await renderPlanPng(painter);

    // Pas de galerie sur le web : on télécharge.
    if (kIsWeb) {
      await downloadPlan(bytes, name);
      messenger.showSnackBar(SnackBar(content: Text(l10n.planDownloaded)));
      return true;
    }

    // Sans l'extension : `gal` la déduit des octets.
    await Gal.putImageBytes(bytes, name: name.replaceAll('.png', ''));
    // « Voir » ouvre la galerie sur l'image qui vient d'être écrite.
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.planSaved),
        // `persist` vaut `action != null` par défaut : il faut forcer
        // l'effacement.
        persist: false,
        action: SnackBarAction(label: l10n.planView, onPressed: Gal.open),
      ),
    );
    return true;
  } on GalException catch (error) {
    // Le refus d'accès est le seul échec que l'utilisateur peut corriger.
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          error.type == GalExceptionType.accessDenied
              ? l10n.planPhotosDenied
              : l10n.planSaveFailed,
        ),
      ),
    );
    return false;
  } catch (error, stack) {
    debugPrint('Enregistrement du plan impossible : $error\n$stack');
    messenger.showSnackBar(SnackBar(content: Text(l10n.planSaveFailed)));
    return false;
  }
}

/// Rend le plan et le confie à la feuille de partage du système.
///
/// Rend `true` si le fichier a bien été remis au système.
Future<bool> sharePlan(
  BuildContext context, {
  required PlanPainter painter,
  required Tool tool,
  required DateTime date,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final exportFailed = AppLocalizations.of(context).planExportFailed;
  final name = planFileName(tool, date);

  try {
    final bytes = await renderPlanPng(painter);
    final result = await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(bytes, mimeType: 'image/png', name: name)],
        // `XFile.fromData` perd son nom hors du web.
        fileNameOverrides: [name],
      ),
    );
    return result.status != ShareResultStatus.unavailable;
  } catch (error, stack) {
    // Message court à l'écran, détail dans la console.
    debugPrint('Export du plan impossible : $error\n$stack');
    messenger.showSnackBar(SnackBar(content: Text(exportFailed)));
    return false;
  }
}
