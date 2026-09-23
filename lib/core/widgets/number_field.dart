import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import 'field_help.dart';
import 'haptics.dart';
import 'labeled_field.dart';

/// Champ numérique : clavier numérique par défaut, gros texte, hauteur fixe
/// [kFieldHeight] — au-dessus de la cible tactile minimale.
///
/// Notifie à chaque frappe — le calcul est temps réel, il n'y a pas de bouton
/// « calculer ».
///
/// Si [step] est fourni, le champ est encadré de boutons − / + : ajustement
/// au pouce sans ouvrir le clavier, appui maintenu pour défiler.
class NumberField extends StatefulWidget {
  const NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.suffix,
    this.help,
    this.about,
    this.decimal = true,
    this.step,
    this.min = 0,
    this.max = double.infinity,
    super.key,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final String? suffix;

  /// Précision courte affichée sous le champ.
  final String? help;

  /// Explication ouverte à la demande — cf. [LabeledField.about].
  final FieldHelp? about;

  final bool decimal;

  /// Pas des boutons − / +. `null` = pas de boutons.
  final double? step;

  final double min;
  final double max;

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  late final TextEditingController _controller = TextEditingController(
    text: _format(widget.value),
  );

  @override
  void didUpdateWidget(NumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Ne réécrit le texte que si la valeur a changé hors frappe (boutons,
    // restauration) — sinon le curseur sauterait à chaque caractère saisi.
    if (widget.value != oldWidget.value &&
        _parse(_controller.text) != widget.value) {
      _controller.text = _format(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _bump(double delta) {
    final next = (widget.value + delta).clamp(widget.min, widget.max);
    // Coupe la dérive des doubles : 0.1 + 0.2 ne doit pas donner 0.30000000004.
    final rounded = double.parse(next.toStringAsFixed(4));
    if (rounded == widget.value) return;
    hapticSelection(context);
    widget.onChanged(rounded);
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    // Hauteur fixe : le champ occupe exactement [kFieldHeight], quel que soit
    // le style de texte. `expands` fait remplir la boîte à la décoration, et
    // le texte reste centré dedans.
    final field = SizedBox(
      height: kFieldHeight,
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.numberWithOptions(decimal: widget.decimal),
        textAlign: step == null ? TextAlign.start : TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        expands: true,
        maxLines: null,
        minLines: null,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            widget.decimal ? RegExp(r'[0-9.,]') : RegExp(r'[0-9]'),
          ),
        ],
        style: controlTextStyle(context),
        decoration: InputDecoration(suffixText: widget.suffix),
        onChanged: (raw) {
          final parsed = _parse(raw);
          if (parsed != null) widget.onChanged(parsed);
        },
      ),
    );

    return LabeledField(
      label: widget.label,
      help: widget.help,
      about: widget.about,
      child: step == null
          ? field
          : Row(
              children: [
                _StepButton(
                  icon: Icons.remove,
                  onStep: widget.value > widget.min ? () => _bump(-step) : null,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: field),
                const SizedBox(width: AppSpacing.sm),
                _StepButton(
                  icon: Icons.add,
                  onStep: widget.value < widget.max ? () => _bump(step) : null,
                ),
              ],
            ),
    );
  }

  static double? _parse(String raw) =>
      double.tryParse(raw.replaceAll(',', '.'));

  static String _format(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : '$v';
}

/// Bouton − / + : un appui = un pas, un appui maintenu fait défiler.
///
/// Tous les gestes sont portés par un seul `GestureDetector` — imbriquer un
/// `IconButton` mettrait deux détecteurs en concurrence dans l'arène.
class _StepButton extends StatefulWidget {
  const _StepButton({required this.icon, required this.onStep});

  final IconData icon;

  /// `null` = borne atteinte, bouton désactivé.
  final VoidCallback? onStep;

  @override
  State<_StepButton> createState() => _StepButtonState();
}

class _StepButtonState extends State<_StepButton> {
  Timer? _holdDelay;
  Timer? _repeat;
  bool _repeated = false;
  bool _pressed = false;

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
    final scheme = Theme.of(context).colorScheme;
    final enabled = widget.onStep != null;

    return GestureDetector(
      onTapDown: enabled ? _onTapDown : null,
      onTapUp: (_) => _stop(),
      onTapCancel: _stop,
      onTap: enabled ? _onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        // Aligné sur la hauteur du champ qu'il encadre.
        height: kFieldHeight,
        width: kFieldHeight,
        decoration: BoxDecoration(
          color: _pressed
              ? scheme.primary.withValues(alpha: 0.18)
              : scheme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppRadii.field),
          border: Border.all(
            color: enabled
                ? scheme.primary.withValues(alpha: 0.4)
                : scheme.outlineVariant,
          ),
        ),
        child: Icon(
          widget.icon,
          color: enabled ? scheme.primary : scheme.outlineVariant,
        ),
      ),
    );
  }
}
