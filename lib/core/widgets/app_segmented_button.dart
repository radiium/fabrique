import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';

/// Une option de [AppSegmentedButton].
class AppSegment<T> {
  const AppSegment({required this.value, required this.label});

  final T value;
  final String label;
}

/// Sélecteur à choix unique : une piste beige, et une pastille brune qui
/// glisse sous l'option choisie.
///
/// Écrit à la main plutôt que dérivé de `SegmentedButton` : Material force un
/// `RoundedRectangleBorder` carré sur chaque segment (le `shape` du style
/// n'est lu que pour le contour général) et détoure les segments sur ce
/// contour. La pastille arrondie posée *dans* la piste y est donc hors
/// d'atteinte, quel que soit le `ButtonStyle`.
///
/// Chaque segment est tabulable et activable au clavier (Espace / Entrée) :
/// l'app tourne aussi sur le Web, où un contrôle uniquement tactile serait
/// inatteignable.
class AppSegmentedButton<T> extends StatefulWidget {
  const AppSegmentedButton({
    required this.segments,
    required this.value,
    required this.onChanged,
    this.height = kFieldHeight,
    this.haptics = true,
    super.key,
  });

  final List<AppSegment<T>> segments;

  /// Option courante. Si elle n'est dans aucun segment, aucune pastille.
  final T value;

  final ValueChanged<T> onChanged;

  /// Aligné par défaut sur la hauteur d'un champ de saisie.
  final double height;

  /// TODO(ui): câbler sur le réglage global « retour haptique ».
  final bool haptics;

  /// Jeu entre la pastille et le bord de la piste.
  static const double _inset = 4;

  /// Rayon de la pastille : concentrique à la piste, donc le rayon de celle-ci
  /// moins le jeu qui l'en sépare. Sans cette soustraction, deux arrondis de
  /// même rayon séparés par une marge ne paraissent pas parallèles.
  static const double _thumbRadius = AppRadii.field - _inset;

  static const Duration _duration = Duration(milliseconds: 180);

  @override
  State<AppSegmentedButton<T>> createState() => _AppSegmentedButtonState<T>();
}

class _AppSegmentedButtonState<T> extends State<AppSegmentedButton<T>> {
  int? _focused;
  int? _hovered;

  @override
  Widget build(BuildContext context) {
    final segments = widget.segments;
    final selected = segments.indexWhere((s) => s.value == widget.value);

    return SizedBox(
      height: widget.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.field,
          // Même rayon qu'un champ ou un bouton : les contrôles d'une carte
          // partagent leur arrondi.
          borderRadius: BorderRadius.circular(AppRadii.field),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          children: [
            if (selected >= 0)
              _overlay(
                index: selected,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.accentDeep,
                    borderRadius: BorderRadius.circular(
                      AppSegmentedButton._thumbRadius,
                    ),
                  ),
                ),
              ),
            // Filet accent de 2 px, comme un champ qui prend le focus.
            if (_focused != null)
              _overlay(
                index: _focused!,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppSegmentedButton._thumbRadius,
                    ),
                    border: Border.all(color: AppColors.accent, width: 2),
                  ),
                ),
              ),
            // Les libellés portent la même marge horizontale que la pastille
            // pour rester centrés dessus, mais occupent toute la hauteur :
            // la cible tactile est la piste entière, pas la pastille.
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSegmentedButton._inset,
                ),
                child: Row(
                  children: [
                    for (final (i, segment) in segments.indexed)
                      Expanded(
                        child: _Segment(
                          label: segment.label,
                          selected: i == selected,
                          hovered: i == _hovered,
                          onTap: () => _select(segment.value),
                          onFocusChange: (v) =>
                              setState(() => _focused = v ? i : null),
                          onHoverChange: (v) =>
                              setState(() => _hovered = v ? i : null),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Une couche posée sur le segment [index], à la géométrie de la pastille.
  Widget _overlay({required int index, required Widget child}) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(AppSegmentedButton._inset),
        child: AnimatedAlign(
          duration: AppSegmentedButton._duration,
          curve: Curves.easeOutCubic,
          alignment: Alignment(_thumbX(index), 0),
          child: FractionallySizedBox(
            widthFactor: 1 / widget.segments.length,
            heightFactor: 1,
            child: child,
          ),
        ),
      ),
    );
  }

  /// Position de la pastille en coordonnées d'[Alignment] : -1 à gauche,
  /// +1 à droite.
  double _thumbX(int index) => widget.segments.length == 1
      ? 0
      : -1 + 2 * index / (widget.segments.length - 1);

  void _select(T next) {
    if (next == widget.value) return;
    if (widget.haptics) unawaited(HapticFeedback.selectionClick());
    widget.onChanged(next);
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.hovered,
    required this.onTap,
    required this.onFocusChange,
    required this.onHoverChange,
  });

  final String label;
  final bool selected;
  final bool hovered;
  final VoidCallback onTap;
  final ValueChanged<bool> onFocusChange;
  final ValueChanged<bool> onHoverChange;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Colors.white
        : (hovered ? AppColors.accentDeep : AppColors.label);

    return Semantics(
      button: true,
      selected: selected,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: onFocusChange,
        onShowHoverHighlight: onHoverChange,
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              onTap();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: AppSegmentedButton._duration,
              // Le style de contrôle du design system, partagé avec les
              // champs et les entrées de panneau déroulant.
              style:
                  (controlTextStyle(context, emphasized: selected) ??
                          const TextStyle())
                      .copyWith(color: color),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
