import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'app_card.dart';
import 'app_disclosure.dart';
import 'haptics.dart';

/// Squelette commun à tous les écrans-outils.
///
/// Mobile : saisie, schéma, résultats empilés. Au-delà de [kWideBreakpoint] :
/// saisie et résultats à gauche, schéma à droite. Les cartes sont posées ici.
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

  /// La saisie en groupes repliables ([AppDisclosure]), à la place d'[input],
  /// quand elle ne tient pas sur un écran.
  final List<Widget>? inputGroups;

  final Widget visualization;

  /// Le format de la vignette sur mobile. Plus haute, elle éloigne les
  /// résultats.
  final double visualizationAspectRatio;

  /// Une liste : la carte intercale les séparateurs.
  final List<Widget> results;

  /// Pied de la carte de résultats, de bord à bord, avec son filet : la place
  /// d'[AppCardActions].
  final Widget? resultsFooter;

  /// Rend la saisie de l'outil à ses valeurs par défaut.
  ///
  /// Dans l'`AppBar`, hors de la zone du pouce. `null` masque l'action.
  final VoidCallback? onReset;

  /// `false` grise l'action sans la masquer : l'écran est neuf.
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

    // Les groupes portent marges et filets. La carte détoure ses coins pour
    // l'encre des en-têtes.
    return AppCard(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: AppDisclosureGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [...?groups],
        ),
      ),
    );
  }
}

/// La carte de résultats, sans rembourrage : les [ResultTile] portent le
/// leur, pour que le tap pour copier prenne toute la ligne. Filets entre les
/// tuiles seulement.
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
          // Sans `Divider` : le pied porte son propre filet.
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

/// « Réinitialiser » : un tap, sans confirmation ni « Annuler ».
///
/// Les cotes se remesurent ; le retour haptique sert d'accusé de réception.
class _ResetAction extends StatelessWidget {
  const _ResetAction({required this.onReset, required this.enabled});

  final VoidCallback onReset;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.restart_alt),
      tooltip: AppLocalizations.of(context).commonReset,
      onPressed: enabled
          ? () {
              hapticImpact(context);
              onReset();
            }
          : null,
    );
  }
}
