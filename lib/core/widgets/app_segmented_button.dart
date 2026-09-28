import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'haptics.dart';

/// Une option de [AppSegmentedButton].
class AppSegment<T> {
  const AppSegment({required this.value, required this.label});

  final T value;
  final String label;
}

/// Sélecteur à choix unique : une piste beige, et une pastille brune qui
/// glisse sous l'option choisie.
///
/// Écrit à la main : `SegmentedButton` détoure ses segments en carré.
/// Chaque segment se tabule et s'active au clavier, pour le web.
class AppSegmentedButton<T> extends StatefulWidget {
  const AppSegmentedButton({
    required this.segments,
    required this.value,
    required this.onChanged,
    this.height = kFieldHeight,
    super.key,
  });

  final List<AppSegment<T>> segments;

  /// Option courante. Si elle n'est dans aucun segment, aucune pastille.
  final T value;

  final ValueChanged<T> onChanged;

  /// Aligné par défaut sur la hauteur d'un champ de saisie.
  final double height;

  /// Jeu entre la pastille et le bord de la piste.
  static const double _inset = 4;

  /// Rayon de la pastille, concentrique à la piste : son rayon moins le jeu.
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
          borderRadius: BorderRadius.circular(AppRadii.field),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          children: [
            if (selected >= 0)
              _ThumbLayer(
                index: selected,
                count: segments.length,
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
            if (_focused case final focused?)
              _ThumbLayer(
                index: focused,
                count: segments.length,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppSegmentedButton._thumbRadius,
                    ),
                    border: Border.all(color: AppColors.accent, width: 2),
                  ),
                ),
              ),
            // Toute la hauteur : la cible tactile est la piste entière.
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

  void _select(T next) {
    if (next == widget.value) return;
    hapticSelection(context);
    widget.onChanged(next);
  }
}

/// Une couche posée sur le segment [index], à la géométrie de la pastille.
///
/// Rend un [Positioned] : à poser directement dans le `Stack` de la piste.
class _ThumbLayer extends StatelessWidget {
  const _ThumbLayer({
    required this.index,
    required this.count,
    required this.child,
  });

  final int index;
  final int count;
  final Widget child;

  /// Position de la pastille en coordonnées d'[Alignment] : -1 à gauche,
  /// +1 à droite.
  double get _x => count == 1 ? 0 : -1 + 2 * index / (count - 1);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(AppSegmentedButton._inset),
        child: AnimatedAlign(
          duration: AppSegmentedButton._duration,
          curve: Curves.easeOutCubic,
          alignment: Alignment(_x, 0),
          child: FractionallySizedBox(
            widthFactor: 1 / count,
            heightFactor: 1,
            child: child,
          ),
        ),
      ),
    );
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
        ? AppColors.onAccent
        : (hovered ? AppColors.accentDeep : AppColors.label);

    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
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
