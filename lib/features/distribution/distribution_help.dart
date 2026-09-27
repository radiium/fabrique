/// Les explications des champs de la Répartition, groupées pour se relire
/// d'un bloc — c'est un texte, il se corrige comme un texte.
///
/// Ce qu'elles disent et ce qu'elles taisent :
/// - jamais la paraphrase du libellé (« entrez le nombre d'éléments ») ;
/// - la conséquence sur le résultat quand il y en a une (le nombre de jeux,
///   les deux bornes entières) ;
/// - le vocabulaire de l'atelier, pas celui du code.
library;

import '../../core/widgets/field_help.dart';
import '../../l10n/app_localizations.dart';

FieldHelp aboutMode(AppLocalizations l10n) => FieldHelp(
  title: l10n.distributionModeLabel,
  body: l10n.distributionAboutModeBody,
  bullets: [l10n.distributionAboutModeSpacing, l10n.distributionAboutModeCount],
);

FieldHelp aboutLength(AppLocalizations l10n) => FieldHelp(
  title: l10n.distributionLength,
  body: l10n.distributionAboutLengthBody,
);

FieldHelp aboutElementWidth(AppLocalizations l10n) => FieldHelp(
  title: l10n.distributionElementWidth,
  body: l10n.distributionAboutElementWidthBody,
);

FieldHelp aboutCount(AppLocalizations l10n) => FieldHelp(
  title: l10n.distributionCount,
  body: l10n.distributionAboutCountBody,
);

FieldHelp aboutTargetSpacing(AppLocalizations l10n) => FieldHelp(
  title: l10n.distributionTargetSpacing,
  body: l10n.distributionAboutTargetBody,
);

FieldHelp aboutEdges(AppLocalizations l10n) => FieldHelp(
  title: l10n.distributionEdges,
  body: l10n.distributionAboutEdgesBody,
);

FieldHelp aboutOffsetMode(AppLocalizations l10n) => FieldHelp(
  title: l10n.distributionMargins,
  body: l10n.distributionAboutMarginsBody,
  bullets: [
    l10n.distributionAboutMarginsSymmetric,
    l10n.distributionAboutMarginsAsymmetric,
  ],
);

FieldHelp aboutOffset(AppLocalizations l10n) => FieldHelp(
  title: l10n.distributionMargin,
  body: l10n.distributionAboutMarginBody,
);

FieldHelp aboutOffsetStart(AppLocalizations l10n) => FieldHelp(
  title: l10n.distributionMarginStart,
  body: l10n.distributionAboutMarginStartBody,
);

FieldHelp aboutOffsetEnd(AppLocalizations l10n) => FieldHelp(
  title: l10n.distributionMarginEnd,
  body: l10n.distributionAboutMarginEndBody,
);
