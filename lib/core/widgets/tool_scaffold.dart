import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'app_card.dart';
import 'app_disclosure.dart';
import 'haptics.dart';

/// Squelette commun à tous les écrans-outils.
///
/// Mobile : saisie / visualisation / résultats empilés. Web large
/// (≥ [kWideBreakpoint]) : deux colonnes, saisie + résultats à gauche,
/// visualisation fixe à droite.
///
/// C'est ici que les trois blocs reçoivent leur carte : claire pour la saisie
/// et les résultats, teintée pour le schéma (via `SchemaCard`). Les écrans
/// passent donc leur contenu nu.
class ToolScaffold extends StatelessWidget {
  const ToolScaffold({
    required this.title,
    required this.visualization,
    required this.results,
    this.input,
    this.inputGroups,
    this.visualizationAspectRatio = 16 / 10,
    this.resultsFooter,
    this.onReset,
    this.canReset = true,
    super.key,
  }) : assert(
         (input == null) != (inputGroups == null),
         'Une saisie d’un seul bloc, ou en groupes : l’un ou l’autre.',
       );

  final String title;

  /// La saisie d'un seul bloc, dans le rembourrage de la carte.
  final Widget? input;

  /// La saisie découpée en groupes repliables ([AppDisclosure]), empilés de
  /// bord à bord à la place d'[input].
  ///
  /// Pour un outil dont la saisie ne tient pas sur un écran : chaque groupe
  /// fermé résume ses valeurs, et le schéma remonte d'autant.
  final List<Widget>? inputGroups;

  final Widget visualization;

  /// Le format de la vignette sur mobile.
  ///
  /// Un outil ne le relève que s'il a vraiment de quoi remplir la hauteur : ce
  /// qu'il prend éloigne d'autant les résultats.
  final double visualizationAspectRatio;

  /// Les résultats arrivent en liste, pas en `Column` toute faite : c'est la
  /// carte qui intercale les séparateurs, donc c'est elle qui doit voir les
  /// éléments un par un.
  final List<Widget> results;

  /// Pied de la carte de résultats, posé hors de son rembourrage : il va de
  /// bord à bord et porte lui-même son filet.
  ///
  /// C'est la place d'[AppCardActions] : ce qu'on fait des résultats se propose
  /// sous les résultats, une fois qu'ils sont lus.
  final Widget? resultsFooter;

  /// Rend la saisie de l'outil à ses valeurs par défaut.
  ///
  /// L'action vit dans l'`AppBar` et non dans une barre basse : une barre fixe
  /// retrancherait ~75 px de chaque écran en permanence — la ressource même
  /// pour laquelle le schéma se bat — au profit d'une action utilisée une fois
  /// par chantier. Et le bas d'écran, c'est la zone du pouce : y poser l'action
  /// la moins rattrapable de l'app, c'est demander l'appui accidentel. Ici
  /// l'`AppBar` existe déjà, donc le coût vertical est nul et le coin opposé au
  /// pouce rend l'appui délibéré.
  ///
  /// `null` = l'outil n'a rien à réinitialiser (le Niveau, qui ne lit que le
  /// capteur) et l'action ne s'affiche pas.
  final VoidCallback? onReset;

  /// Y a-t-il quelque chose à réinitialiser ?
  ///
  /// `false` grise l'action au lieu de la faire disparaître : une chrome qui
  /// s'efface se cherche, une icône éteinte se lit — et elle porte le seul
  /// signal « rien n'a été restauré, l'écran est neuf ».
  final bool canReset;

  @override
  Widget build(BuildContext context) {
    final reset = onReset;
    final inputCard = _InputCard(input: input, groups: inputGroups);
    final resultsCard = _ResultsCard(results: results, footer: resultsFooter);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (reset != null) _ResetAction(onReset: reset, enabled: canReset),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) =>
              constraints.maxWidth >= kWideBreakpoint
              ? _WideBody(
                  inputCard: inputCard,
                  resultsCard: resultsCard,
                  visualization: visualization,
                )
              : _NarrowBody(
                  inputCard: inputCard,
                  resultsCard: resultsCard,
                  visualization: visualization,
                  visualizationAspectRatio: visualizationAspectRatio,
                ),
        ),
      ),
    );
  }
}

/// La carte de saisie : un bloc dans son rembourrage, ou des groupes.
class _InputCard extends StatelessWidget {
  const _InputCard({required this.input, required this.groups});

  final Widget? input;
  final List<Widget>? groups;

  @override
  Widget build(BuildContext context) {
    if (input case final input?) return AppCard(child: input);

    // Les groupes portent leurs marges et leurs filets : la carte n'a rien à
    // leur prêter. Elle détoure ses coins, sinon l'encre d'un en-tête
    // déborderait des arrondis. Le filet du premier se confond avec son bord.
    return AppCard(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [...?groups],
      ),
    );
  }
}

/// Les [ResultTile] portent tout leur rembourrage : la carte n'en pose aucun.
///
/// Un rembourrage de carte donnerait à la première et à la dernière tuile un
/// blanc de plus qu'aux autres, et arrêterait la zone tapable avant le bord —
/// alors que le tap pour copier doit attraper toute la ligne.
///
/// Les filets vont de bord à bord (la carte détoure), et jamais avant le
/// premier ni après le dernier : ils séparent, ils n'encadrent pas.
class _ResultsCard extends StatelessWidget {
  const _ResultsCard({required this.results, required this.footer});

  final List<Widget> results;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final footer = this.footer;
    return AppCard(
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, result) in results.indexed) ...[
            if (i > 0) const Divider(),
            result,
          ],
          // Sans `Divider` : le pied porte son propre filet, comme celui de la
          // carte de saisie, et deux traits superposés se verraient.
          ?footer,
        ],
      ),
    );
  }
}

/// Web large : saisie et résultats à gauche, schéma fixe à droite.
class _WideBody extends StatelessWidget {
  const _WideBody({
    required this.inputCard,
    required this.resultsCard,
    required this.visualization,
  });

  final Widget inputCard;
  final Widget resultsCard;
  final Widget visualization;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                inputCard,
                const SizedBox(height: AppSpacing.md),
                resultsCard,
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: visualization,
          ),
        ),
      ],
    );
  }
}

/// Mobile : saisie, schéma, résultats, empilés.
class _NarrowBody extends StatelessWidget {
  const _NarrowBody({
    required this.inputCard,
    required this.resultsCard,
    required this.visualization,
    required this.visualizationAspectRatio,
  });

  final Widget inputCard;
  final Widget resultsCard;
  final Widget visualization;
  final double visualizationAspectRatio;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          inputCard,
          const SizedBox(height: AppSpacing.md),
          // Schéma compact, agrandi au tap.
          AspectRatio(
            aspectRatio: visualizationAspectRatio,
            child: visualization,
          ),
          const SizedBox(height: AppSpacing.md),
          resultsCard,
        ],
      ),
    );
  }
}

/// « Réinitialiser » : un tap, pas de dialogue, pas de SnackBar « Annuler ».
///
/// Les cotes ne vivent pas dans l'app — elles viennent du mètre, du tasseau,
/// de la pièce. Un reset accidentel ne détruit rien, il fait retaper ce qui
/// est encore mesurable à un mètre de là. Confirmer punirait les appuis voulus
/// (l'écrasante majorité) pour couvrir une erreur rare et bon marché, et le
/// SnackBar recouvrirait les résultats à chaque reset intentionnel.
///
/// Le retour haptique est donc le seul accusé de réception : il ne coûte ni
/// tap ni pixel, et il s'entend quand la scie tourne.
class _ResetAction extends StatelessWidget {
  const _ResetAction({required this.onReset, required this.enabled});

  final VoidCallback onReset;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.restart_alt),
      tooltip: 'Réinitialiser la saisie',
      onPressed: enabled
          ? () {
              hapticImpact(context);
              onReset();
            }
          : null,
    );
  }
}
