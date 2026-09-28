/// Les libellés des choix des Tiroirs, partagés par l'écran et le cartouche du
/// plan.
library;

import '../../core/calc/drawers.dart';
import '../../l10n/app_localizations.dart';

extension DrawerPartLabel on DrawerPart {
  String label(AppLocalizations l10n) => switch (this) {
    DrawerPart.side => l10n.drawerPartSide,
    DrawerPart.front => l10n.drawerPartFront,
    DrawerPart.back => l10n.drawerPartBack,
    DrawerPart.bottom => l10n.drawerPartBottom,
    DrawerPart.drawerFront => l10n.drawerPartDrawerFront,
  };
}

extension SlideKindLabel on SlideKind {
  String label(AppLocalizations l10n) => switch (this) {
    SlideKind.ballBearing => l10n.slideBallBearing,
    SlideKind.undermount => l10n.slideUndermount,
    SlideKind.woodOnWood => l10n.slideWoodOnWood,
    SlideKind.custom => l10n.slideCustom,
  };
}

extension FrontMountLabel on FrontMount {
  /// Court : ces libellés tiennent dans un segment de sélecteur.
  String label(AppLocalizations l10n) => switch (this) {
    FrontMount.overlay => l10n.frontMountOverlay,
    FrontMount.inset => l10n.frontMountInset,
  };
}

extension BoxJointLabel on BoxJoint {
  String label(AppLocalizations l10n) => switch (this) {
    BoxJoint.sidesOverlap => l10n.boxJointSidesOverlap,
    BoxJoint.frontBackOverlap => l10n.boxJointFrontBackOverlap,
  };
}

extension BottomMountLabel on BottomMount {
  String label(AppLocalizations l10n) => switch (this) {
    BottomMount.groove => l10n.bottomMountGroove,
    BottomMount.between => l10n.bottomMountBetween,
    BottomMount.underneath => l10n.bottomMountUnderneath,
  };
}
