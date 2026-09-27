/// Les explications des champs du Calepinage, groupées pour se relire d'un
/// bloc — c'est un texte, il se corrige comme un texte.
///
/// Deux entrées seulement : ce sont les deux notions que le libellé ne peut
/// pas porter. Le reste de l'écran demande des cotes, et une cote s'explique
/// toute seule.
library;

import '../../core/widgets/field_help.dart';
import '../../l10n/app_localizations.dart';

FieldHelp aboutPerimeterGap(AppLocalizations l10n) => FieldHelp(
  title: l10n.layoutPerimeterGap,
  body: l10n.layoutAboutPerimeterBody,
  bullets: [
    l10n.layoutAboutPerimeterFlooring,
    l10n.layoutAboutPerimeterTile,
    l10n.layoutAboutPerimeterDrywall,
    l10n.layoutAboutPerimeterNone,
  ],
);

FieldHelp aboutOffset(AppLocalizations l10n) => FieldHelp(
  title: l10n.layoutOffset,
  body: l10n.layoutAboutOffsetBody,
  bullets: [
    l10n.layoutAboutOffsetStraight,
    l10n.layoutAboutOffsetHalf,
    l10n.layoutAboutOffsetThird,
    l10n.layoutAboutOffsetSquare,
  ],
);
