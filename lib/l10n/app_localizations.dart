import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('it'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @unexpectedErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get unexpectedErrorOccurred;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @top.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get top;

  /// No description provided for @center.
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get center;

  /// No description provided for @bottom.
  ///
  /// In en, this message translates to:
  /// **'Bottom'**
  String get bottom;

  /// No description provided for @sixHours.
  ///
  /// In en, this message translates to:
  /// **'6 hours'**
  String get sixHours;

  /// No description provided for @twelveHours.
  ///
  /// In en, this message translates to:
  /// **'12 hours'**
  String get twelveHours;

  /// No description provided for @twentyFourHours.
  ///
  /// In en, this message translates to:
  /// **'24 hours'**
  String get twentyFourHours;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @currencies.
  ///
  /// In en, this message translates to:
  /// **'Currencies'**
  String get currencies;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @fetchCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Fetch Currencies'**
  String get fetchCurrencies;

  /// No description provided for @fetchingCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Fetching Currencies'**
  String get fetchingCurrencies;

  /// No description provided for @chooseYourFavoriteCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Choose your favorite currencies.\\nThese will be pinned to the home screen.'**
  String get chooseYourFavoriteCurrencies;

  /// No description provided for @searchByNameOrSymbol.
  ///
  /// In en, this message translates to:
  /// **'Search by name or symbol (e.g. USD)'**
  String get searchByNameOrSymbol;

  /// No description provided for @noSelectedCurrencies.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any currencies selected yet. \nAdd some by clicking the button below.'**
  String get noSelectedCurrencies;

  /// No description provided for @manageCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Manage Currencies'**
  String get manageCurrencies;

  /// No description provided for @selectAnOption.
  ///
  /// In en, this message translates to:
  /// **'Select an option'**
  String get selectAnOption;

  /// No description provided for @roundDecimalsTo.
  ///
  /// In en, this message translates to:
  /// **'Round decimals to'**
  String get roundDecimalsTo;

  /// No description provided for @updateFrequency.
  ///
  /// In en, this message translates to:
  /// **'Update frequency'**
  String get updateFrequency;

  /// No description provided for @useLargeInputs.
  ///
  /// In en, this message translates to:
  /// **'Use large inputs'**
  String get useLargeInputs;

  /// No description provided for @showDragToReorderHandles.
  ///
  /// In en, this message translates to:
  /// **'Show drag to reorder handles'**
  String get showDragToReorderHandles;

  /// No description provided for @showCopyToClipboardButtons.
  ///
  /// In en, this message translates to:
  /// **'Show copy to clipboard buttons'**
  String get showCopyToClipboardButtons;

  /// No description provided for @showFullCurrencyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Show full currency name label'**
  String get showFullCurrencyNameLabel;

  /// No description provided for @alignInputsTo.
  ///
  /// In en, this message translates to:
  /// **'Align inputs to'**
  String get alignInputsTo;

  /// No description provided for @showCurrentRates.
  ///
  /// In en, this message translates to:
  /// **'Show current rates'**
  String get showCurrentRates;

  /// No description provided for @accountForInflation.
  ///
  /// In en, this message translates to:
  /// **'Account for inflation'**
  String get accountForInflation;

  /// No description provided for @showCountryFlags.
  ///
  /// In en, this message translates to:
  /// **'Show country flags'**
  String get showCountryFlags;

  /// No description provided for @allowDecimalInput.
  ///
  /// In en, this message translates to:
  /// **'Allow decimal input'**
  String get allowDecimalInput;

  /// No description provided for @exchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Exchange Rate'**
  String get exchangeRate;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @themeDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the app\'s appearance: light, dark, or system default'**
  String get themeDescription;

  /// No description provided for @languageDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the display language for the app'**
  String get languageDescription;

  /// No description provided for @roundDecimalsToDescription.
  ///
  /// In en, this message translates to:
  /// **'Set how many decimal places to show in results'**
  String get roundDecimalsToDescription;

  /// No description provided for @updateFrequencyDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how often exchange rates are refreshed'**
  String get updateFrequencyDescription;

  /// No description provided for @useLargeInputsDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable larger input fields for easier tapping'**
  String get useLargeInputsDescription;

  /// No description provided for @showDragToReorderHandlesDescription.
  ///
  /// In en, this message translates to:
  /// **'Show drag handles to reorder currency inputs'**
  String get showDragToReorderHandlesDescription;

  /// No description provided for @showCopyToClipboardButtonsDescription.
  ///
  /// In en, this message translates to:
  /// **'Display buttons to copy conversion results'**
  String get showCopyToClipboardButtonsDescription;

  /// No description provided for @showFullCurrencyNameLabelDescription.
  ///
  /// In en, this message translates to:
  /// **'Show full currency names alongside symbols'**
  String get showFullCurrencyNameLabelDescription;

  /// No description provided for @alignInputsToDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose text alignment for input fields'**
  String get alignInputsToDescription;

  /// No description provided for @showCurrentRatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Display the current exchange rate beneath conversions'**
  String get showCurrentRatesDescription;

  /// No description provided for @accountForInflationDescription.
  ///
  /// In en, this message translates to:
  /// **'Adjust conversion results for inflation over time'**
  String get accountForInflationDescription;

  /// No description provided for @showCountryFlagsDescription.
  ///
  /// In en, this message translates to:
  /// **'Show country flags next to currency symbols'**
  String get showCountryFlagsDescription;

  /// No description provided for @allowDecimalInputDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow entering decimal points in input fields'**
  String get allowDecimalInputDescription;

  /// No description provided for @inflationHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Account for Inflation'**
  String get inflationHelpTitle;

  /// No description provided for @inflationHelpContent.
  ///
  /// In en, this message translates to:
  /// **'Enable accounting for inflation to make entering currencies with large inflated rates automatically multiply by 1,000 for easier input.\n\nFor example, if 5,000.00 COP = \$1 USD, you can just enter 5 COP and it will treat it as 5,000.00 for convenience.'**
  String get inflationHelpContent;

  /// No description provided for @unableToRefreshCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Unable to refresh currency data'**
  String get unableToRefreshCurrencies;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @noInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetTitle;

  /// No description provided for @noInternetMessage.
  ///
  /// In en, this message translates to:
  /// **'Cnvrt could not connect.\nCheck your internet connection.'**
  String get noInternetMessage;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @languageItalian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get languageItalian;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get languageChinese;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get languageKorean;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'it', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'it':
      return AppLocalizationsIt();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
