// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get error => 'Error';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get system => 'System';

  @override
  String get settings => 'Settings';

  @override
  String get currencies => 'Currencies';

  @override
  String get units => 'Units';

  @override
  String get chooseYourFavoriteCurrencies =>
      'Choose your favorite currencies.\\nThese will be pinned to the home screen.';

  @override
  String get searchByNameOrSymbol => 'Search by name or symbol (e.g. USD)';

  @override
  String get noSelectedCurrencies =>
      'You don\'t have any currencies selected yet. \nAdd some by clicking the button below.';

  @override
  String get manageCurrencies => 'Manage Currencies';

  @override
  String get selectAnOption => 'Select an option';

  @override
  String get roundDecimalsTo => 'Round decimals to';

  @override
  String get updateFrequency => 'Update frequency';

  @override
  String get useLargeInputs => 'Use large inputs';

  @override
  String get showDragToReorderHandles => 'Show drag to reorder handles';

  @override
  String get showCopyToClipboardButtons => 'Show copy to clipboard buttons';

  @override
  String get showFullCurrencyNameLabel => 'Show full currency name label';

  @override
  String get alignInputsTo => 'Align inputs to';

  @override
  String get showCurrentRates => 'Show current rates';

  @override
  String get accountForInflation => 'Account for inflation';

  @override
  String get showCountryFlags => 'Show country flags';

  @override
  String get allowDecimalInput => 'Allow decimal input';

  @override
  String get all => 'All';

  @override
  String get selected => 'Selected';

  @override
  String get none => 'None';

  @override
  String get temperature => 'Temperature';

  @override
  String get distance => 'Distance';

  @override
  String get speed => 'Speed';

  @override
  String get weight => 'Weight';

  @override
  String get area => 'Area';

  @override
  String get volume => 'Volume';

  @override
  String get themeDescription =>
      'Choose the app\'s appearance: light, dark, or system default';

  @override
  String get languageDescription => 'Select the display language for the app';

  @override
  String get roundDecimalsToDescription =>
      'Set how many decimal places to show in results';

  @override
  String get updateFrequencyDescription =>
      'Choose how often exchange rates are refreshed';

  @override
  String get useLargeInputsDescription =>
      'Enable larger input fields for easier tapping';

  @override
  String get showDragToReorderHandlesDescription =>
      'Show drag handles to reorder currency inputs';

  @override
  String get showCopyToClipboardButtonsDescription =>
      'Display buttons to copy conversion results';

  @override
  String get showFullCurrencyNameLabelDescription =>
      'Show full currency names alongside symbols';

  @override
  String get alignInputsToDescription =>
      'Choose text alignment for input fields';

  @override
  String get showCurrentRatesDescription =>
      'Display the current exchange rate beneath conversions';

  @override
  String get accountForInflationDescription =>
      'Adjust conversion results for inflation over time';

  @override
  String get showCountryFlagsDescription =>
      'Show country flags next to currency symbols';

  @override
  String get allowDecimalInputDescription =>
      'Allow entering decimal points in input fields';

  @override
  String get inflationHelpTitle => 'Account for Inflation';

  @override
  String get inflationHelpContent =>
      'When enabled, this feature adjusts currency conversion results to account for inflation over time.\n\nInflation is the rate at which the general level of prices for goods and services rises, causing purchasing power to fall. This means that money today is worth more than the same amount of money in the future.\n\nFor example:\nIf you\'re comparing currency values from different time periods, enabling this option will adjust the conversion to reflect the real purchasing power difference, not just the nominal exchange rate.\n\nThis is particularly useful when analyzing historical exchange rates or making financial comparisons across different time periods.\n\nNote: Inflation calculations use historical data and may vary by country and time period.';
}
