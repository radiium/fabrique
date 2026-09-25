import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'field_help.dart';
import 'haptics.dart';
import 'labeled_field.dart';
import 'numeric_input.dart';

/// Nombre d'éléments, entier et borné, encadré de boutons − / +.
///
/// Les boutons sont d'office : un nombre d'éléments s'essaie (« et avec un de
/// plus ? ») sans ouvrir le clavier, appui maintenu pour défiler. Les bornes
/// sont obligatoires, elles désactivent le bouton qui en sortirait.
///
/// Toujours seul sur sa ligne : trois cibles de [kFieldHeight] ne tiennent pas
/// dans une demi-largeur de téléphone.
class CountField extends StatelessWidget {
  const CountField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    this.help,
    this.about,
    super.key,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  /// Précision courte affichée sous le champ.
  final String? help;

  /// Explication ouverte à la demande — cf. [LabeledField.about].
  final FieldHelp? about;

  void _bump(BuildContext context, int delta) {
    final next = (value + delta).clamp(min, max);
    if (next == value) return;
    hapticSelection(context);
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    // Une frappe hors bornes passe telle quelle : c'est au calcul de la
    // refuser avec un message, pas au champ de la corriger en silence.
    return LabeledField(
      label: label,
      help: help,
      about: about,
      child: Row(
        children: [
          _StepButton(
            icon: Icons.remove,
            tooltip: 'Un de moins',
            onStep: value > min ? () => _bump(context, -1) : null,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: NumericInput(
              value: value.toDouble(),
              onChanged: (v) => onChanged(v.round()),
              decimal: false,
              textAlign: TextAlign.center,
              semanticLabel: label,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _StepButton(
            icon: Icons.add,
            tooltip: 'Un de plus',
            onStep: value < max ? () => _bump(context, 1) : null,
          ),
        ],
      ),
    );
  }
}

/// Bouton − / + : un appui = un pas, un appui maintenu fait défiler.
///
/// Tous les gestes sont portés par un seul `GestureDetector` — imbriquer un
/// `IconButton` mettrait deux détecteurs en concurrence dans l'arène.
///
/// Tabulable et activable au clavier (Espace / Entrée), comme les segments :
/// sur le Web, un bouton seulement tactile serait inatteignable.
class _StepButton extends StatefulWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.onStep,
  });

  final IconData icon;

  /// Libellé pour un lecteur d'écran, infobulle sur le web.
  final String tooltip;

  /// `null` = borne atteinte, bouton désactivé.
  final VoidCallback? onStep;

  /// L'opacité Material d'un contrôle éteint.
  static const double _disabledOpacity = 0.38;

  @override
  State<_StepButton> createState() => _StepButtonState();
}

class _StepButtonState extends State<_StepButton> {
  Timer? _holdDelay;
  Timer? _repeat;
  bool _repeated = false;
  bool _pressed = false;
  bool _focused = false;

  void _onTapDown(TapDownDetails _) {
    setState(() => _pressed = true);
    _repeated = false;
    _holdDelay = Timer(const Duration(milliseconds: 400), () {
      _repeated = true;
      _repeat = Timer.periodic(
        const Duration(milliseconds: 70),
        (_) => widget.onStep?.call(),
      );
    });
  }

  void _stop() {
    _holdDelay?.cancel();
    _repeat?.cancel();
    _holdDelay = null;
    _repeat = null;
    if (_pressed) setState(() => _pressed = false);
  }

  // Un appui maintenu a déjà incrémenté via le timer : ne pas compter en plus
  // le tap de relâchement.
  void _onTap() {
    if (!_repeated) widget.onStep?.call();
  }

  @override
  void dispose() {
    _holdDelay?.cancel();
    _repeat?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onStep != null;

    return Tooltip(
      message: widget.tooltip,
      child: Semantics(
        button: true,
        enabled: enabled,
        child: FocusableActionDetector(
          enabled: enabled,
          mouseCursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
          onShowFocusHighlight: (v) => setState(() => _focused = v),
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                widget.onStep?.call();
                return null;
              },
            ),
          },
          child: GestureDetector(
            onTapDown: enabled ? _onTapDown : null,
            onTapUp: (_) => _stop(),
            onTapCancel: _stop,
            onTap: enabled ? _onTap : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 80),
              // Aligné sur la hauteur du champ qu'il encadre.
              height: kFieldHeight,
              width: kFieldHeight,
              // Le fond et le filet d'un champ ; le focus, le filet accent de
              // 2 px d'un champ qui prend la main.
              decoration: BoxDecoration(
                color: _pressed ? AppColors.accentWash : AppColors.field,
                borderRadius: BorderRadius.circular(AppRadii.field),
                border: _focused
                    ? Border.all(color: AppColors.accent, width: 2)
                    : Border.all(color: AppColors.border),
              ),
              child: Icon(
                widget.icon,
                color: enabled
                    ? AppColors.accentDeep
                    : AppColors.label.withValues(
                        alpha: _StepButton._disabledOpacity,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
