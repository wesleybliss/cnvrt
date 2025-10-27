// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get helloWorld => '¡Hola Mundo!';

  @override
  String get error => 'Error';

  @override
  String get unexpectedErrorOccurred => 'Se produjo un error inesperado.';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Idioma';

  @override
  String get system => 'Sistema';

  @override
  String get dark => 'Oscuro';

  @override
  String get light => 'Claro';

  @override
  String get top => 'Arriba';

  @override
  String get center => 'Centro';

  @override
  String get bottom => 'Abajo';

  @override
  String get sixHours => '6 horas';

  @override
  String get twelveHours => '12 horas';

  @override
  String get twentyFourHours => '24 horas';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get favorites => 'Favoritos';

  @override
  String get settings => 'Ajustes';

  @override
  String get currency => 'Moneda';

  @override
  String get currencies => 'Monedas';

  @override
  String get units => 'Unidades';

  @override
  String get fetchCurrencies => 'Obtener Divisas';

  @override
  String get fetchingCurrencies => 'Obtención de Divisas';

  @override
  String get chooseYourFavoriteCurrencies =>
      'Elige tus monedas favoritas.\\nEstas se mostrarán en la pantalla de inicio.';

  @override
  String get searchByNameOrSymbol => 'Busca por nombre o símbolo (p. ej. USD)';

  @override
  String get noSelectedCurrencies =>
      'Aún no has seleccionado ninguna moneda.\nAñade algunas haciendo clic en el botón de abajo.';

  @override
  String get manageCurrencies => 'Administrar Monedas';

  @override
  String get selectAnOption => 'Selecciona una opción';

  @override
  String get roundDecimalsTo => 'Redondear decimales a';

  @override
  String get updateFrequency => 'Frecuencia de actualización';

  @override
  String get useLargeInputs => 'Usar entradas grandes';

  @override
  String get showDragToReorderHandles =>
      'Mostrar los controladores de arrastrar para reordenar';

  @override
  String get showCopyToClipboardButtons =>
      'Mostrar los botones de copiar al portapapeles';

  @override
  String get showFullCurrencyNameLabel =>
      'Mostrar la etiqueta del nombre completo de la moneda';

  @override
  String get alignInputsTo => 'Alinear las entradas a';

  @override
  String get showCurrentRates => 'Mostrar las tasas actuales';

  @override
  String get accountForInflation => 'Tener en cuenta la inflación';

  @override
  String get showCountryFlags => 'Mostrar banderas de países';

  @override
  String get allowDecimalInput => 'Permitir entrada decimal';

  @override
  String get exchangeRate => 'Tipo de cambio';

  @override
  String get all => 'Todo';

  @override
  String get selected => 'Seleccionado';

  @override
  String get none => 'Ninguno';

  @override
  String get temperature => 'Temperatura';

  @override
  String get distance => 'Distancia';

  @override
  String get speed => 'Velocidad';

  @override
  String get weight => 'Peso';

  @override
  String get area => 'Área';

  @override
  String get volume => 'Volumen';

  @override
  String get themeDescription =>
      'Elige la apariencia de la aplicación: claro, oscuro o predeterminado del sistema';

  @override
  String get languageDescription =>
      'Selecciona el idioma de visualización de la aplicación';

  @override
  String get roundDecimalsToDescription =>
      'Establece cuántos decimales mostrar en los resultados';

  @override
  String get updateFrequencyDescription =>
      'Elige con qué frecuencia se actualizan las tasas de cambio';

  @override
  String get useLargeInputsDescription =>
      'Activa campos de entrada más grandes para facilitar el uso';

  @override
  String get showDragToReorderHandlesDescription =>
      'Muestra controles para arrastrar y reordenar entradas de moneda';

  @override
  String get showCopyToClipboardButtonsDescription =>
      'Muestra botones para copiar los resultados de conversión';

  @override
  String get showFullCurrencyNameLabelDescription =>
      'Muestra el nombre completo de la moneda junto al símbolo';

  @override
  String get alignInputsToDescription =>
      'Elige la alineación de texto para los campos de entrada';

  @override
  String get showCurrentRatesDescription =>
      'Muestra la tasa de cambio actual debajo de las conversiones';

  @override
  String get accountForInflationDescription =>
      'Ajusta los resultados de conversión por inflación a lo largo del tiempo';

  @override
  String get showCountryFlagsDescription =>
      'Muestra banderas de países junto a los símbolos de moneda';

  @override
  String get allowDecimalInputDescription =>
      'Permite ingresar puntos decimales en los campos de entrada';

  @override
  String get inflationHelpTitle => 'Tener en cuenta la inflación';

  @override
  String get inflationHelpContent =>
      'Habilita la contabilización de inflación para facilitar la entrada de monedas con tasas infladas grandes, multiplicando automáticamente por 1.000.\n\nPor ejemplo, si 5.000,00 COP = \$1 USD, solo necesitas ingresar 5 COP y se tratará como 5.000,00 para mayor comodidad.';

  @override
  String get unableToRefreshCurrencies =>
      'No se pueden actualizar los datos de moneda';

  @override
  String get retry => 'Reintentar';

  @override
  String get dismiss => 'Descartar';

  @override
  String get noInternetTitle => 'Sin conexión a Internet';

  @override
  String get noInternetMessage =>
      'Cnvrt no pudo conectarse.\nVerifica tu conexión a Internet.';

  @override
  String get tryAgain => 'Intentar de Nuevo';
}
