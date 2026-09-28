import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';

/// Saisie numérique nue, sans libellé : le socle commun de `NumberField` et de
/// `CountField`.
///
/// Hauteur [kFieldHeight], clavier numérique, notifie à chaque frappe.
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

  /// Le nom du champ pour un lecteur d'écran, le libellé visible étant un
  /// autre nœud.
  final String? semanticLabel;

  @override
  State<NumericInput> createState() => _NumericInputState();
}

class _NumericInputState extends State<NumericInput> {
  // Tardif : le séparateur décimal se lit dans le contexte, au `build`.
  late final TextEditingController _controller = TextEditingController(
    text: _format(widget.value),
  );

  @override
  void didUpdateWidget(NumericInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Réécrit seulement si la valeur a changé hors frappe, sinon le curseur
    // saute.
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
    // `expands` remplit la boîte de [kFieldHeight], texte centré.
    return SizedBox(
      height: kFieldHeight,
      // `Semantics` simple : un `MergeSemantics` fait lever `RenderEditable`.
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

  /// La valeur telle qu'on la taperait : sans zéros inutiles, avec le
  /// séparateur décimal de la langue. [_parse] relit les deux séparateurs.
  String _format(double v) => v == v.roundToDouble()
      ? v.toStringAsFixed(0)
      : '$v'.replaceFirst('.', AppLocalizations.of(context).decimalSeparator);
}
