import '../core/format.dart';
import 'app_localizations.dart';

/// Les nombres affichés, avec le séparateur décimal de la langue.
///
/// Passer par ici plutôt que par [formatNumber] nu : c'est ce qui écrit
/// `2,5` en français et `2.5` en anglais.
extension NumberText on AppLocalizations {
  String number(double? value) =>
      formatNumber(value, decimalSeparator: decimalSeparator);

  String degrees(double? value) =>
      formatDegrees(value, decimalSeparator: decimalSeparator);
}
