import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'app_card.dart';
import 'app_disclosure.dart';
import 'haptics.dart';

/// Squelette commun à tous les écrans-outils.
///
/// Mobile : saisie / visualisation / résultats empilés, la visualisation reste
/// visible sans scroll. Web large (> [kWideBreakpoint]) : deux colonnes,
/// saisie + résultats à gauche, visualisation fixe à droite.
///
/// C'est ici que les trois blocs reçoivent leur carte : claire pour la saisie
/// et les résultats, teintée pour le schéma (via `SchemaCard`). Les écrans
/// passent donc leur contenu nu.
class ToolScaffold extends StatelessWidget {
  const ToolScaffold({
    required this.title,
    required this.input,
    required this.visualization,
    required this.results,
    this.visualizationAspectRatio = 16 / 10,
    this.inputFooter,
    this.resultsFooter,
    this.onReset,
    this.canReset = true,
    super.key,
  });

  final String title;
  final Widget input;

  /// Pied de la carte de saisie, posé **hors** de son rembourrage : il va de
  /// bord à bord et porte lui-même ses marges (cf. [AppDisclosure]).
  ///
  /// C'est la place du panneau « réglages avancés » : replié, il ne coûte
  /// qu'une ligne en bas de carte ; déplié, il pousse le schéma sans jamais
  /// s'intercaler entre deux champs.
  final Widget? inputFooter;

  final Widget visualization;

  /// Le format de la vignette sur mobile.
  ///
  /// Un outil ne le relève que s'il a vraiment de quoi remplir la hauteur : ce
  /// qu'il prend, il le prend à la ligne de flottaison, qui est la ressource
  /// la plus disputée de l'écran.
  final double visualizationAspectRatio;

  /// Les résultats arrivent en liste, pas en `Column` toute faite : c'est la
  /// carte qui intercale les séparateurs, donc c'est elle qui doit voir les
  /// éléments un par un.
  final List<Widget> results;

  /// Pied de la carte de résultats — le symétrique d'[inputFooter], posé de la
  /// même façon hors du rembourrage et portant lui-même son filet.
  ///
  /// C'est la place d'[AppCardAction] : ce qu'on fait des résultats se propose
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
    final inputCard = _InputCard(input: input, footer: inputFooter);
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

/// La carte de saisie, et son pied éventuel.
class _InputCard extends StatelessWidget {
  const _InputCard({required this.input, required this.footer});

  final Widget input;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final footer = this.footer;
    if (footer == null) return AppCard(child: input);

    // Rembourrage annulé au profit du corps : c'est la seule façon de laisser
    // le pied toucher les trois bords. La carte détoure alors ses coins, sinon
    // l'encre du pied déborderait des arrondis du bas.
    return AppCard(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(padding: const EdgeInsets.all(AppSpacing.md), child: input),
          footer,
        ],
      ),
    );
  }
}

/// Les [ResultTile] portent tout leur rembourrage : la carte n'en pose aucun.
///
/// Sans ça, la première et la dernière tuile prenaient un blanc en plus que
/// les autres, et la zone tapable s'arrêtait avant le bord de la carte —
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
          // Schéma compact, visible sans scroll, agrandi au tap.
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
