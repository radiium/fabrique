import '../core/format.dart';
import 'app_localizations.dart';

/// Les nombres affichés, avec le séparateur décimal de la langue.
///
/// À préférer à [formatNumber] : `2,5` en français, `2.5` en anglais.
extension NumberText on AppLocalizations {
  String number(double? value) =>
      formatNumber(value, decimalSeparator: decimalSeparator);

  String degrees(double? value) =>
      formatDegrees(value, decimalSeparator: decimalSeparator);
}
