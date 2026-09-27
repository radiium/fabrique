/// Sortie d'un plan : le PNG, et la remise au système.
///
/// Un seul format. Le PNG s'ouvre partout, s'affiche dans une conversation
/// sans être téléchargé, et s'imprime comme le reste — un PDF n'apporterait
/// que l'impression, que l'image assure déjà.
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
/// 200 et non 150 : le cartouche écrit en corps 8,5 sur une feuille cotée en
/// 594 unités, soit 33 px ici. À 150 dpi il en resterait 25, et une valeur de
/// cote se lirait mal une fois la feuille punaisée.
const int kPlanPixelWidth = 2339;

/// Rend le plan en PNG.
///
/// Le painter se rejoue hors de l'arbre de widgets : il ne reçoit que des
/// données, donc la définition du fichier ne doit rien à l'appareil qui
/// l'exporte. Capturer la page affichée rendrait au contraire la vignette
/// telle qu'elle est à l'écran, à la résolution du téléphone de celui qui
/// partage.
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

/// `fabrique-distribution-2026-09-23.png`.
///
/// L'outil et la date dans le nom : un dossier de chantier finit par en
/// contenir plusieurs, et `image.png` ne se retrouve pas.
String planFileName(Tool tool, DateTime date) {
  String two(int v) => v.toString().padLeft(2, '0');
  return 'fabrique-${tool.id}-${date.year}-${two(date.month)}-'
      '${two(date.day)}.png';
}

/// Rend le plan et le garde : dans les photos sur mobile, dans les
/// téléchargements sur le web.
///
/// **Le premier des deux gestes, et le seul qui ne dépende de personne.** Le
/// sélecteur de partage d'Android ne liste que des applications : il n'y a
/// aucune action « enregistrer » dedans. Un plan qu'on ne peut que partager est
/// un plan qu'on ne peut pas simplement garder.
///
/// **Dans les photos, sans rien demander.** C'est le seul endroit que tout le
/// monde sait rouvrir, et d'où le téléphone sait déjà imprimer et envoyer. Un
/// dossier au choix coûterait une boîte de dialogue à chaque export, et un
/// dossier mémorisé demanderait à Android une autorisation d'arbre persistante
/// — donc un paquet de plus, et un chemin qui périme quand le dossier
/// disparaît. Qui veut ranger ailleurs passe par « Partager ».
///
/// **Sans album, ni droit de lecture.** Une app de bricolage n'a rien à faire à
/// lire les photos de qui que ce soit.
///
/// Rend `true` si l'image est enregistrée.
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

    // Le navigateur n'a pas de galerie : « garder » y veut dire télécharger.
    // Passer par la feuille de partage serait un détour, et l'API Web Share ne
    // prend les fichiers que sur une poignée de navigateurs.
    if (kIsWeb) {
      await downloadPlan(bytes, name);
      messenger.showSnackBar(SnackBar(content: Text(l10n.planDownloaded)));
      return true;
    }

    // Sans l'extension : `gal` la pose lui-même, d'après les octets.
    await Gal.putImageBytes(bytes, name: name.replaceAll('.png', ''));
    // « Voir » plutôt qu'un simple accusé de réception : un enregistrement
    // qu'on ne peut pas vérifier oblige à sortir de l'app pour aller chercher
    // si le plan est bien là, et à recommencer quand on ne le trouve pas.
    // La galerie s'ouvre sur son dernier élément, qui vient d'être écrit.
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.planSaved),
        // `persist` vaut `action != null` par défaut : un SnackBar qui porte
        // une action reste à l'écran indéfiniment. Ici c'est un accusé de
        // réception, pas une question — il doit s'effacer tout seul.
        persist: false,
        action: SnackBarAction(label: l10n.planView, onPressed: Gal.open),
      ),
    );
    return true;
  } on GalException catch (error) {
    // Le refus d'accès est le seul échec que l'utilisateur puisse corriger,
    // donc le seul qui mérite autre chose que le message générique.
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
/// Le second geste : envoyer le plan à quelqu'un, ou l'ouvrir dans une autre
/// app. C'est au système de lister les destinations, pas à nous — une boîte de
/// dialogue maison referait moins bien, et une destination imposée se
/// tromperait une fois sur deux.
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
        // `XFile.fromData` perd son nom partout sauf sur le web : sans cette
        // reprise, le fichier partagé s'appelle comme le fichier temporaire.
        fileNameOverrides: [name],
      ),
    );
    return result.status != ShareResultStatus.unavailable;
  } catch (error, stack) {
    // Le message reste court à l'écran : devant la scie, un détail technique
    // n'aide personne. Le détail part dans la console, seul endroit où il sert.
    debugPrint('Export du plan impossible : $error\n$stack');
    messenger.showSnackBar(SnackBar(content: Text(exportFailed)));
    return false;
  }
}
