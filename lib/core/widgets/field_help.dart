import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// L'explication d'un champ : ce qu'on est content de lire la première fois,
/// et qu'on ne relit jamais.
///
/// Écrit comme une donnée et non comme un widget : le même contenu doit
/// pouvoir s'ouvrir depuis le champ *et* se retrouver un jour dans un panneau
/// « comment marche cet outil » sans être récrit.
///
/// Règle de rédaction : le [body] dit ce que le libellé ne dit pas. Une
/// paraphrase du libellé (« Entrez le nombre d'éléments ») coûte un tap pour
/// rien et apprend à ne plus ouvrir les suivantes.
@immutable
class FieldHelp {
  const FieldHelp({
    required this.title,
    required this.body,
    this.bullets = const [],
  });

  /// En général le libellé du champ, repris tel quel : on doit reconnaître
  /// d'où la feuille s'est ouverte.
  final String title;

  final String body;

  /// Points détachés, pour ce qui s'énumère — les options d'un sélecteur.
  final List<String> bullets;
}

/// Ouvre l'explication dans une feuille basse.
///
/// Feuille plutôt que dépliant en place : la carte de saisie apparie des
/// champs sur une même ligne ([NumberField] côte à côte), et un panneau qui
/// pousse le contenu ferait grandir la ligne sous un seul des deux, avec un
/// texte à demi-largeur qui part sur quatre lignes.
///
/// Feuille plutôt que popover : elle se renvoie d'un glissement n'importe où
/// ou d'un tap sur le voile, là où un popover demande de viser à côté — geste
/// de précision qui, avec un gant, atterrit sur un autre contrôle et change
/// une cote. Et le jour où l'explication mérite un croquis, la feuille le
/// porte.
///
/// La carte de saisie étant en haut de l'écran, la feuille recouvre les
/// résultats, jamais le champ dont on parle.
Future<void> showFieldHelp(BuildContext context, FieldHelp help) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: AppColors.cardSurface,
    // `isScrollControlled` : sans lui la feuille est bornée à la moitié de
    // l'écran et un texte un peu long se tronque au lieu de défiler.
    isScrollControlled: true,
    builder: (context) => _FieldHelpSheet(help: help),
  );
}

class _FieldHelpSheet extends StatelessWidget {
  const _FieldHelpSheet({required this.help});

  final FieldHelp help;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body = theme.textTheme.bodyLarge?.copyWith(height: 1.45);

    return SafeArea(
      child: Padding(
        // La poignée de glissement occupe déjà le haut.
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(help.title, style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              Text(help.body, style: body),
              for (final bullet in help.bullets) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Un tiret cadratin plutôt qu'une puce : ici il sépare
                    // visuellement, il n'est pas de la ponctuation de phrase.
                    Text('—', style: body?.copyWith(color: AppColors.label)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(bullet, style: body)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
