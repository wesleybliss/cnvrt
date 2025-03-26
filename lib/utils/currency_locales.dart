
/*String formatCurrency(String currencyCode, int amount) {
  final locale = currencyLocales[currencyCode] ?? 'en_US';
  return NumberFormat.currency(locale: locale, decimalDigits: 0).format(amount);
}*/

// Example usage
// print(formatCurrency('USD', 1234)); // "$1,234"
// print(formatCurrency('JPY', 1234)); // "¥1,234"

final Map<String, String> currencyLocales = {
  "COP": "es_CO", // Colombia
  "USD": "en_US", // United States
  "AED": "ar_AE", // United Arab Emirates
  "AFN": "fa_AF", // Afghanistan
  "ALL": "sq_AL", // Albania
  "AMD": "hy_AM", // Armenia
  "ANG": "nl_CW", // Curaçao (Netherlands Antilles)
  "AOA": "pt_AO", // Angola
  "ARS": "es_AR", // Argentina
  "AUD": "en_AU", // Australia
  "AWG": "nl_AW", // Aruba
  "AZN": "az_AZ", // Azerbaijan
  "BAM": "bs_BA", // Bosnia and Herzegovina
  "BBD": "en_BB", // Barbados
  "BDT": "bn_BD", // Bangladesh
  "BGN": "bg_BG", // Bulgaria
  "BHD": "ar_BH", // Bahrain
  "BIF": "fr_BI", // Burundi
  "BMD": "en_BM", // Bermuda
  "BND": "ms_BN", // Brunei
  "BOB": "es_BO", // Bolivia
  "BRL": "pt_BR", // Brazil
  "BSD": "en_BS", // Bahamas
  "BTC": "en_US", // Bitcoin (no official locale, using en_US as default)
  "BTN": "dz_BT", // Bhutan
  "BWP": "en_BW", // Botswana
  "BYN": "be_BY", // Belarus
  "BZD": "en_BZ", // Belize
  "CAD": "en_CA", // Canada
  "CDF": "fr_CD", // Congo (DRC)
  "CHF": "de_CH", // Switzerland (German-speaking region)
  "CLF": "es_CL", // Chile (Unit of Account)
  "CLP": "es_CL", // Chile
  "CNH": "zh_CN", // China (offshore Yuan)
  "CNY": "zh_CN", // China
  "CRC": "es_CR", // Costa Rica
  "CUC": "es_CU", // Cuba (Convertible Peso)
  "CUP": "es_CU", // Cuba
  "CVE": "pt_CV", // Cape Verde
  "CZK": "cs_CZ", // Czech Republic
  "DJF": "fr_DJ", // Djibouti
  "DKK": "da_DK", // Denmark
  "DOP": "es_DO", // Dominican Republic
  "DZD": "ar_DZ", // Algeria
  "EGP": "ar_EG", // Egypt
  "ERN": "ti_ER", // Eritrea
  "ETB": "am_ET", // Ethiopia
  "EUR": "en_EU", // Eurozone (using en_EU as a general representation)
  "FJD": "en_FJ", // Fiji
  "FKP": "en_FK", // Falkland Islands
  "GBP": "en_GB", // United Kingdom
  "GEL": "ka_GE", // Georgia
  "GGP": "en_GG", // Guernsey
  "GHS": "en_GH", // Ghana
  "GIP": "en_GI", // Gibraltar
  "GMD": "en_GM", // Gambia
  "GNF": "fr_GN", // Guinea
  "GTQ": "es_GT", // Guatemala
  "GYD": "en_GY", // Guyana
  "HKD": "zh_HK", // Hong Kong
  "HNL": "es_HN", // Honduras
  "HRK": "hr_HR", // Croatia
  "HTG": "fr_HT", // Haiti
  "HUF": "hu_HU", // Hungary
  "IDR": "id_ID", // Indonesia
  "ILS": "he_IL", // Israel
  "IMP": "en_IM", // Isle of Man
  "INR": "hi_IN", // India
  "IQD": "ar_IQ", // Iraq
  "IRR": "fa_IR", // Iran
  "ISK": "is_IS", // Iceland
  "JEP": "en_JE", // Jersey
  "JMD": "en_JM", // Jamaica
  "JOD": "ar_JO", // Jordan
  "JPY": "ja_JP", // Japan
  "KES": "sw_KE", // Kenya
  "KGS": "ky_KG", // Kyrgyzstan
  "KHR": "km_KH", // Cambodia
  "KMF": "fr_KM", // Comoros
  "KPW": "ko_KP", // North Korea
  "KRW": "ko_KR", // South Korea
  "KWD": "ar_KW", // Kuwait
  "KYD": "en_KY", // Cayman Islands
  "KZT": "kk_KZ", // Kazakhstan
  "LAK": "lo_LA", // Laos
  "LBP": "ar_LB", // Lebanon
  "LKR": "si_LK", // Sri Lanka
  "LRD": "en_LR", // Liberia
  "LSL": "st_LS", // Lesotho
  "LYD": "ar_LY", // Libya
  "MAD": "ar_MA", // Morocco
  "MDL": "ro_MD", // Moldova
  "MGA": "mg_MG", // Madagascar
  "MKD": "mk_MK", // North Macedonia
  "MMK": "my_MM", // Myanmar
  "MNT": "mn_MN", // Mongolia
  "MOP": "zh_MO", // Macau
  "MRO": "ar_MR", // Mauritania (old)
  "MRU": "ar_MR", // Mauritania
  "MUR": "en_MU", // Mauritius
  "MVR": "dv_MV", // Maldives
  "MWK": "en_MW", // Malawi
  "MXN": "es_MX", // Mexico
  "MYR": "ms_MY", // Malaysia
  "MZN": "pt_MZ", // Mozambique
  "NAD": "en_NA", // Namibia
  "NGN": "en_NG", // Nigeria
  "NIO": "es_NI", // Nicaragua
  "NOK": "nb_NO", // Norway
  "NPR": "ne_NP", // Nepal
  "NZD": "en_NZ", // New Zealand
  "OMR": "ar_OM", // Oman
  "PAB": "es_PA", // Panama
  "PEN": "es_PE", // Peru
  "PGK": "en_PG", // Papua New Guinea
  "PHP": "fil_PH", // Philippines
  "PKR": "ur_PK", // Pakistan
  "PLN": "pl_PL", // Poland
  "PYG": "es_PY", // Paraguay
  "QAR": "ar_QA", // Qatar
  "RON": "ro_RO", // Romania
  "RSD": "sr_RS", // Serbia
  "RUB": "ru_RU", // Russia
  "RWF": "rw_RW", // Rwanda
  "SAR": "ar_SA", // Saudi Arabia
  "SBD": "en_SB", // Solomon Islands
  "SCR": "fr_SC", // Seychelles
  "SDG": "ar_SD", // Sudan
  "SEK": "sv_SE", // Sweden
  "SGD": "en_SG", // Singapore
  "SHP": "en_SH", // Saint Helena
  "SLL": "en_SL", // Sierra Leone
  "SOS": "so_SO", // Somalia
  "SRD": "nl_SR", // Suriname
  "SSP": "en_SS", // South Sudan
  "STD": "pt_ST", // São Tomé and Príncipe (old)
  "STN": "pt_ST", // São Tomé and Príncipe
  "SVC": "es_SV", // El Salvador
  "SYP": "ar_SY", // Syria
  "SZL": "ss_SZ", // Eswatini
  "THB": "th_TH", // Thailand
  "TJS": "tg_TJ", // Tajikistan
  "TMT": "tk_TM", // Turkmenistan
  "TND": "ar_TN", // Tunisia
  "TOP": "to_TO", // Tonga
  "TRY": "tr_TR", // Turkey
  "TTD": "en_TT", // Trinidad and Tobago
  "TWD": "zh_TW", // Taiwan
  "TZS": "sw_TZ", // Tanzania
  "UAH": "uk_UA", // Ukraine
  "UGX": "en_UG", // Uganda
  "UYU": "es_UY", // Uruguay
  "UZS": "uz_UZ", // Uzbekistan
  "VEF": "es_VE", // Venezuela (old)
  "VES": "es_VE", // Venezuela
  "VND": "vi_VN", // Vietnam
  "VUV": "bi_VU", // Vanuatu
  "WST": "sm_WS", // Samoa
  "XAF": "fr_XAF", // Central African CFA franc (multiple countries)
  "XAG": "en_US", // Silver (no official locale, using en_US)
  "XAU": "en_US", // Gold (no official locale, using en_US)
  "XCD": "en_XCD", // Eastern Caribbean Dollar (multiple countries)
  "XDR": "en_US", // Special Drawing Rights (IMF, using en_US)
  "XOF": "fr_XOF", // West African CFA franc (multiple countries)
  "XPD": "en_US", // Palladium (no official locale, using en_US)
  "XPF": "fr_PF", // CFP franc (French Polynesia)
  "XPT": "en_US", // Platinum (no official locale, using en_US)
  "YER": "ar_YE", // Yemen
  "ZAR": "en_ZA", // South Africa
  "ZMW": "en_ZM", // Zambia
  "ZWL": "en_ZW", // Zimbabwe
};