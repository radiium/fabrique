import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Le réglage « retour haptique » descendu dans l'arbre, posé une fois à la
/// racine de l'app.
///
/// Les contrôles partagés vibrent à un seul endroit chacun, mais ils sont
/// appelés une trentaine de fois dans les écrans : passer le réglage en
/// paramètre à chaque appel reviendrait à le réclamer à chaque nouveau champ,
/// et à l'oublier une fois. La portée règle la question à la racine, pour tout
/// ce qui est déjà écrit comme pour ce qui viendra.
///
/// Elle ne dépend pas de Riverpod : c'est [FabriqueApp] qui `watch` le
/// provider et alimente la portée. Les widgets de `core/widgets` restent donc
/// du Flutter nu, montables seuls dans un test sans `ProviderScope`.
class HapticsScope extends InheritedWidget {
  const HapticsScope({required this.enabled, required super.child, super.key});

  final bool enabled;

  /// L'état du réglage, `true` en l'absence de portée.
  ///
  /// Lecture **sans dépendance** : l'appelant est un gestionnaire de geste, pas
  /// un `build`. Il consulte le réglage à l'instant où il vibre, et un
  /// changement de réglage n'a donc aucun contrôle à reconstruire.
  static bool of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<HapticsScope>()?.enabled ?? true;

  @override
  bool updateShouldNotify(HapticsScope oldWidget) =>
      oldWidget.enabled != enabled;
}

/// Petit accusé de réception : changement de valeur, de segment, d'onglet.
void hapticSelection(BuildContext context) {
  if (HapticsScope.of(context)) unawaited(HapticFeedback.selectionClick());
}

/// Accusé de réception d'une action qui efface une saisie — le « réinitialiser »
/// des outils. Plus franc que [hapticSelection] parce qu'il est le seul retour
/// d'une action sans confirmation.
void hapticImpact(BuildContext context) {
  if (HapticsScope.of(context)) unawaited(HapticFeedback.mediumImpact());
}
