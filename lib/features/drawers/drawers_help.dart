/// Les explications des champs des Tiroirs, groupées pour se relire d'un bloc.
library;

import '../../core/widgets/field_help.dart';
import '../../l10n/app_localizations.dart';

FieldHelp aboutOpening(AppLocalizations l10n) =>
    FieldHelp(title: l10n.drawersOpening, body: l10n.drawersAboutOpeningBody);

FieldHelp aboutFrontHeights(AppLocalizations l10n) => FieldHelp(
  title: l10n.drawersFrontHeights,
  body: l10n.drawersAboutFrontHeightsBody,
);

FieldHelp aboutSlide(AppLocalizations l10n) => FieldHelp(
  title: l10n.drawersSlide,
  body: l10n.drawersAboutSlideBody,
  bullets: [
    l10n.drawersAboutSlideBallBearing,
    l10n.drawersAboutSlideUndermount,
    l10n.drawersAboutSlideWood,
    l10n.drawersAboutSlideCustom,
  ],
);

FieldHelp aboutFrontMount(AppLocalizations l10n) => FieldHelp(
  title: l10n.drawersFrontMount,
  body: l10n.drawersAboutFrontMountBody,
  bullets: [
    l10n.drawersAboutFrontMountOverlay,
    l10n.drawersAboutFrontMountInset,
  ],
);

FieldHelp aboutBoxJoint(AppLocalizations l10n) =>
    FieldHelp(title: l10n.drawersBoxJoint, body: l10n.drawersAboutBoxJointBody);

FieldHelp aboutBottomMount(AppLocalizations l10n) => FieldHelp(
  title: l10n.drawersBottom,
  body: l10n.drawersAboutBottomBody,
  bullets: [
    l10n.drawersAboutBottomGroove,
    l10n.drawersAboutBottomBetween,
    l10n.drawersAboutBottomUnderneath,
  ],
);

FieldHelp aboutSlideLength(AppLocalizations l10n) => FieldHelp(
  title: l10n.drawersSlideLength,
  body: l10n.drawersAboutSlideLengthBody,
);
