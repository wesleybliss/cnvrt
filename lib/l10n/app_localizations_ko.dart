// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get helloWorld => '안녕하세요!';

  @override
  String get error => '오류';

  @override
  String get unexpectedErrorOccurred => '예기치 않은 오류가 발생했습니다.';

  @override
  String get theme => '테마';

  @override
  String get language => '언어';

  @override
  String get system => '시스템';

  @override
  String get dark => '다크';

  @override
  String get light => '라이트';

  @override
  String get top => '위';

  @override
  String get center => '가운데';

  @override
  String get bottom => '아래';

  @override
  String get sixHours => '6시간';

  @override
  String get twelveHours => '12시간';

  @override
  String get twentyFourHours => '24시간';

  @override
  String get copiedToClipboard => '클립보드에 복사됨';

  @override
  String get favorites => '즐겨찾기';

  @override
  String get settings => '설정';

  @override
  String get currency => '통화';

  @override
  String get currencies => '통화';

  @override
  String get units => '단위';

  @override
  String get fetchCurrencies => '통화 가져오기';

  @override
  String get fetchingCurrencies => '통화 가져오는 중';

  @override
  String get chooseYourFavoriteCurrencies =>
      '자주 사용하는 통화를 선택하세요.\\n홈 화면에 고정됩니다.';

  @override
  String get searchByNameOrSymbol => '이름 또는 기호로 검색 (예: USD)';

  @override
  String get noSelectedCurrencies => '아직 선택한 통화가 없습니다. \\n아래 버튼을 눌러 추가하세요.';

  @override
  String get manageCurrencies => '통화 관리';

  @override
  String get selectAnOption => '옵션 선택';

  @override
  String get roundDecimalsTo => '소수점 반올림';

  @override
  String get updateFrequency => '업데이트 빈도';

  @override
  String get useLargeInputs => '큰 입력 필드 사용';

  @override
  String get showDragToReorderHandles => '드래그 핸들 표시';

  @override
  String get showCopyToClipboardButtons => '클립보드 복사 버튼 표시';

  @override
  String get showFullCurrencyNameLabel => '전체 통화 이름 표시';

  @override
  String get alignInputsTo => '입력 정렬';

  @override
  String get showCurrentRates => '현재 환율 표시';

  @override
  String get accountForInflation => '인플레이션 반영';

  @override
  String get showCountryFlags => '국기 표시';

  @override
  String get allowDecimalInput => '소수점 입력 허용';

  @override
  String get exchangeRate => '환율';

  @override
  String get all => '전체';

  @override
  String get selected => '선택됨';

  @override
  String get none => '없음';

  @override
  String get temperature => '온도';

  @override
  String get distance => '거리';

  @override
  String get speed => '속도';

  @override
  String get weight => '무게';

  @override
  String get area => '면적';

  @override
  String get volume => '부피';

  @override
  String get themeDescription => '앱의 외관 선택: 라이트, 다크 또는 시스템 기본값';

  @override
  String get languageDescription => '앱의 표시 언어 선택';

  @override
  String get roundDecimalsToDescription => '결과에 표시할 소수점 자릿수 설정';

  @override
  String get updateFrequencyDescription => '환율 새로고침 빈도 선택';

  @override
  String get useLargeInputsDescription => '탭하기 쉽도록 더 큰 입력 필드 활성화';

  @override
  String get showDragToReorderHandlesDescription => '통화 입력 순서를 변경할 드래그 핸들 표시';

  @override
  String get showCopyToClipboardButtonsDescription => '변환 결과를 복사하는 버튼 표시';

  @override
  String get showFullCurrencyNameLabelDescription => '기호와 함께 전체 통화 이름 표시';

  @override
  String get alignInputsToDescription => '입력 필드의 텍스트 정렬 선택';

  @override
  String get showCurrentRatesDescription => '변환 아래에 현재 환율 표시';

  @override
  String get accountForInflationDescription => '시간 경과에 따른 인플레이션 조정';

  @override
  String get showCountryFlagsDescription => '통화 기호 옆에 국기 표시';

  @override
  String get allowDecimalInputDescription => '입력 필드에 소수점 입력 허용';

  @override
  String get inflationHelpTitle => '인플레이션 반영';

  @override
  String get inflationHelpContent =>
      '인플레이션 반영을 활성화하면 인플레이션 환율이 높은 통화를 입력할 때 자동으로 1,000을 곱하여 입력을 쉽게 할 수 있습니다.\\n\\n예를 들어, 5,000.00 COP = \$1 USD인 경우, 5 COP만 입력하면 편의상 5,000.00으로 처리됩니다.';

  @override
  String get unableToRefreshCurrencies => '통화 데이터를 새로고침할 수 없습니다';

  @override
  String get retry => '재시도';

  @override
  String get dismiss => '닫기';

  @override
  String get noInternetTitle => '인터넷 연결 없음';

  @override
  String get noInternetMessage => 'Cnvrt가 연결할 수 없습니다.\\n인터넷 연결을 확인하세요.';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get languageEnglish => '영어';

  @override
  String get languageSpanish => '스페인어';

  @override
  String get languageItalian => '이탈리아어';

  @override
  String get languageChinese => '중국어';

  @override
  String get languageKorean => '한국어';
}
