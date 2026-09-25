import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';

/// Saisie numérique nue, sans libellé : le socle commun de `NumberField` et de
/// `CountField`.
///
/// Hauteur fixe [kFieldHeight], clavier numérique, notifie à chaque frappe —
/// le calcul est temps réel, il n'y a pas de bouton « calculer ».
class NumericInput extends StatefulWidget {
  const NumericInput({
    required this.value,
    required this.onChanged,
    this.suffix,
    this.decimal = true,
    this.textAlign = TextAlign.start,
    this.semanticLabel,
    super.key,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final String? suffix;
  final bool decimal;
  final TextAlign textAlign;

  /// Le nom du champ pour un lecteur d'écran : le libellé visible au-dessus
  /// est un nœud à part, et un champ atteint au Tab ou au doigt s'annoncerait
  /// « champ de texte, 250 » sans dire lequel.
  final String? semanticLabel;

  @override
  State<NumericInput> createState() => _NumericInputState();
}

class _NumericInputState extends State<NumericInput> {
  late final TextEditingController _controller = TextEditingController(
    text: _format(widget.value),
  );

  @override
  void didUpdateWidget(NumericInput oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    // Hauteur fixe : le champ occupe exactement [kFieldHeight], quel que soit
    // le style de texte. `expands` fait remplir la boîte à la décoration, et
    // le texte reste centré dedans.
    return SizedBox(
      height: kFieldHeight,
      // Un `Semantics` simple, pas un `MergeSemantics` : l'annotation se fond
      // d'elle-même dans le nœud du champ, alors qu'une fusion forcée fait
      // lever le `RenderEditable`.
      child: Semantics(
        label: widget.semanticLabel,
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.numberWithOptions(
            decimal: widget.decimal,
          ),
          textAlign: widget.textAlign,
          textAlignVertical: TextAlignVertical.center,
          expands: true,
          maxLines: null,
          minLines: null,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              widget.decimal ? _decimalChars : _digits,
            ),
          ],
          style: controlTextStyle(context),
          decoration: InputDecoration(suffixText: widget.suffix),
          onChanged: (raw) {
            final parsed = _parse(raw);
            if (parsed != null) widget.onChanged(parsed);
          },
        ),
      ),
    );
  }

  static final RegExp _decimalChars = RegExp('[0-9.,]');
  static final RegExp _digits = RegExp('[0-9]');

  static double? _parse(String raw) =>
      double.tryParse(raw.replaceAll(',', '.'));

  static String _format(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : '$v';
}
