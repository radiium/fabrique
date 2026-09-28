import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Le réglage « retour haptique », posé à la racine de l'app.
///
/// Sans Riverpod : [FabriqueApp] l'alimente, et les widgets partagés se
/// montent seuls dans un test.
class HapticsScope extends InheritedWidget {
  const HapticsScope({required this.enabled, required super.child, super.key});

  final bool enabled;

  /// L'état du réglage, `true` en l'absence de portée.
  ///
  /// Lu sans dépendance : l'appelant est un gestionnaire de geste.
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

/// Accusé de réception d'un « réinitialiser », plus franc car sans
/// confirmation.
void hapticImpact(BuildContext context) {
  if (HapticsScope.of(context)) unawaited(HapticFeedback.mediumImpact());
}
