// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get helloWorld => '你好世界！';

  @override
  String get error => '错误';

  @override
  String get unexpectedErrorOccurred => '发生了意外错误。';

  @override
  String get theme => '主题';

  @override
  String get language => '语言';

  @override
  String get system => '系统';

  @override
  String get dark => '深色';

  @override
  String get light => '浅色';

  @override
  String get top => '顶部';

  @override
  String get center => '居中';

  @override
  String get bottom => '底部';

  @override
  String get sixHours => '6小时';

  @override
  String get twelveHours => '12小时';

  @override
  String get twentyFourHours => '24小时';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get favorites => '收藏';

  @override
  String get settings => '设置';

  @override
  String get currency => '货币';

  @override
  String get currencies => '货币';

  @override
  String get units => '单位';

  @override
  String get fetchCurrencies => '获取货币';

  @override
  String get fetchingCurrencies => '正在获取货币';

  @override
  String get chooseYourFavoriteCurrencies => '选择您喜欢的货币。\\n这些将显示在主屏幕上。';

  @override
  String get searchByNameOrSymbol => '按名称或符号搜索（例如 USD）';

  @override
  String get noSelectedCurrencies => '您还没有选择任何货币。\\n点击下面的按钮添加一些。';

  @override
  String get manageCurrencies => '管理货币';

  @override
  String get selectAnOption => '选择一个选项';

  @override
  String get roundDecimalsTo => '小数位数';

  @override
  String get updateFrequency => '更新频率';

  @override
  String get useLargeInputs => '使用大输入框';

  @override
  String get showDragToReorderHandles => '显示拖动重新排序手柄';

  @override
  String get showCopyToClipboardButtons => '显示复制到剪贴板按钮';

  @override
  String get showFullCurrencyNameLabel => '显示完整货币名称标签';

  @override
  String get alignInputsTo => '输入框对齐到';

  @override
  String get showCurrentRates => '显示当前汇率';

  @override
  String get accountForInflation => '考虑通货膨胀';

  @override
  String get showCountryFlags => '显示国旗';

  @override
  String get allowDecimalInput => '允许小数输入';

  @override
  String get all => '全部';

  @override
  String get selected => '已选';

  @override
  String get none => '无';

  @override
  String get temperature => '温度';

  @override
  String get distance => '距离';

  @override
  String get speed => '速度';

  @override
  String get weight => '重量';

  @override
  String get area => '面积';

  @override
  String get volume => '体积';

  @override
  String get themeDescription => '选择应用的外观：浅色、深色或系统默认';

  @override
  String get languageDescription => '选择应用的显示语言';

  @override
  String get roundDecimalsToDescription => '设置结果中显示的小数位数';

  @override
  String get updateFrequencyDescription => '选择汇率刷新的频率';

  @override
  String get useLargeInputsDescription => '启用更大的输入框以便于点击';

  @override
  String get showDragToReorderHandlesDescription => '显示拖动手柄以重新排序货币输入';

  @override
  String get showCopyToClipboardButtonsDescription => '显示按钮以复制转换结果';

  @override
  String get showFullCurrencyNameLabelDescription => '在符号旁边显示完整的货币名称';

  @override
  String get alignInputsToDescription => '选择输入框的文本对齐方式';

  @override
  String get showCurrentRatesDescription => '在转换下方显示当前汇率';

  @override
  String get accountForInflationDescription => '根据通货膨胀调整转换结果';

  @override
  String get showCountryFlagsDescription => '在货币符号旁边显示国旗';

  @override
  String get allowDecimalInputDescription => '允许在输入框中输入小数点';

  @override
  String get inflationHelpTitle => '考虑通货膨胀';

  @override
  String get inflationHelpContent =>
      '启用通货膨胀考虑功能，使输入具有大幅通胀汇率的货币时自动乘以1,000，以便更轻松地输入。\\n\\n例如，如果5,000.00 COP = \$1 USD，您只需输入5 COP，它将被视为5,000.00以方便使用。';

  @override
  String get unableToRefreshCurrencies => '无法刷新货币数据';

  @override
  String get retry => '重试';

  @override
  String get dismiss => '关闭';

  @override
  String get noInternetTitle => '无网络连接';

  @override
  String get noInternetMessage => 'Cnvrt无法连接。\\n请检查您的网络连接。';

  @override
  String get tryAgain => '重试';
}
