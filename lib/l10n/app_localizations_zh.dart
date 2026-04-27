// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'StatusInsights';

  @override
  String get navOverview => '概览';

  @override
  String get navReports => '上报';

  @override
  String get navSettings => '设置';

  @override
  String get navAbout => '关于';

  @override
  String get overviewTitle => '概览';

  @override
  String get overviewDescription => '追踪整体服务状态与关键指标。';

  @override
  String get reportsTitle => '上报';

  @override
  String get reportsDescription => '查看趋势、事件和历史报表。';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsDescription => '管理告警偏好与集成。';

  @override
  String get settingsGeneralSection => '通用';

  @override
  String get settingsLanguageLabel => '语言';

  @override
  String get settingsLanguageHelper => '选择应用显示语言。';

  @override
  String get settingsServiceSection => '服务';

  @override
  String get settingsServerAddressLabel => '服务端地址';

  @override
  String get settingsServerAddressHelper => '用于上传与拉取状态数据。';

  @override
  String get settingsServerAddressValue => 'https://api.example.com';

  @override
  String get settingsEditServerAddressTitle => '编辑服务端地址';

  @override
  String get settingsServerAddressInputHint =>
      '请输入完整 URL，例如 https://api.example.com';

  @override
  String get settingsValidationInvalidUrl => '请输入有效的 URL。';

  @override
  String get settingsReportIntervalLabel => '自动上报间隔';

  @override
  String get settingsReportIntervalHelper => '应用自动上报状态的时间间隔。';

  @override
  String get settingsReportIntervalValue => '60 秒';

  @override
  String get settingsEditReportIntervalTitle => '编辑自动上报间隔';

  @override
  String get settingsReportIntervalInputHint => '请输入秒数，例如 60';

  @override
  String get settingsValidationInvalidNumber => '请输入有效的正整数。';

  @override
  String get settingsSecondsUnit => '秒';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => '英文';

  @override
  String get aboutTitle => '关于';

  @override
  String get aboutDescription => 'StatusInsights 版本 1.0.0，基于 Flutter 构建。';
}
