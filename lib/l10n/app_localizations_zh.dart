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
  String get reportsDescription => '手动或自动上报个人与设备状态。';

  @override
  String get reportsPersonSectionTitle => '个人状态上报';

  @override
  String get reportsDeviceSectionTitle => '设备状态上报';

  @override
  String get reportsStatusLabel => '状态';

  @override
  String get reportsDescriptionLabel => '描述';

  @override
  String get reportsManualReportButton => '手动上报';

  @override
  String get reportsRegisterButton => '注册';

  @override
  String get reportsUnregisterButton => '取消注册';

  @override
  String get reportsRegisteredStatus => '已注册';

  @override
  String get reportsUnregisteredStatus => '未注册';

  @override
  String get reportsDeviceNotRegistered => '设备尚未注册，请先注册。';

  @override
  String get reportsRegistrationIndependentHint => '设备上报不依赖本地注册状态判断。';

  @override
  String get reportsActualStatusLabel => '实际上报内容（前台窗口标题）';

  @override
  String get reportsStatusEmpty => '-';

  @override
  String reportsDeviceId(Object value) {
    return 'device_id: $value';
  }

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
  String get settingsThemeModeLabel => '主题模式';

  @override
  String get settingsThemeModeHelper => '自动跟随系统，或手动选择浅色/深色。';

  @override
  String get settingsEditThemeModeTitle => '选择主题模式';

  @override
  String get settingsThemeModeSystemLabel => '自动';

  @override
  String get settingsThemeModeLightLabel => '浅色';

  @override
  String get settingsThemeModeDarkLabel => '深色';

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
  String get settingsApiKeyLabel => 'API Key';

  @override
  String get settingsApiKeyHelper => '请求头 X-API-Key 的值。';

  @override
  String get settingsEditApiKeyTitle => '编辑 API Key';

  @override
  String get settingsApiKeyInputHint => '请输入 API Key';

  @override
  String get settingsWindowTitleBackendLabel => '窗口标题来源';

  @override
  String get settingsWindowTitleBackendHelper => '选择获取前台窗口标题的方式。';

  @override
  String get settingsWindowTitleCommandLabel => '自定义标题命令';

  @override
  String get settingsWindowTitleCommandHelper => '仅在来源为“自定义命令”时使用。';

  @override
  String get settingsEditWindowTitleBackendTitle => '选择窗口标题来源';

  @override
  String get settingsEditWindowTitleCommandTitle => '编辑自定义标题命令';

  @override
  String get settingsWindowTitleCommandInputHint => '请输入命令，输出窗口标题文本';

  @override
  String get settingsWindowTitleBackendAutoLabel => '自动识别';

  @override
  String get settingsWindowTitleBackendNiriLabel => 'niri';

  @override
  String get settingsWindowTitleBackendHyprlandLabel => 'Hyprland';

  @override
  String get settingsWindowTitleBackendSwayLabel => 'sway';

  @override
  String get settingsWindowTitleBackendX11Label => 'X11 (xprop)';

  @override
  String get settingsWindowTitleBackendCustomLabel => '自定义命令';

  @override
  String get settingsValidationInvalidUrl => '请输入有效的 URL。';

  @override
  String get settingsValidationInvalidApiKey => 'API Key 不能为空。';

  @override
  String get settingsValidationInvalidCommand => '命令不能为空。';

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
  String get deviceName => '我的设备';

  @override
  String get deviceNameLabel => '设备名称';

  @override
  String get deviceNameHelper => '为此设备起一个易记的名称。';

  @override
  String get deviceDescription => '用于监控应用和系统状态。';

  @override
  String get deviceDescriptionLabel => '设备描述';

  @override
  String get deviceDescriptionHelper => '简短描述此设备的用途。';

  @override
  String get deviceTypeDesktop => '桌面';

  @override
  String get deviceTypeMobile => '移动';

  @override
  String get deviceTypeUnknown => '未知';

  @override
  String get devicesTitle => '设备';

  @override
  String get statusLoading => '正在加载状态...';

  @override
  String get statusFetchFailed => '获取状态失败';

  @override
  String get statusNoData => '暂无状态数据';

  @override
  String statusTitle(Object name) {
    return '$name 的状态';
  }

  @override
  String get editDeviceInfo => '编辑设备信息';

  @override
  String get deviceInfoUpdateSuccess => '设备信息已更新。';

  @override
  String get deviceInfoUpdateFailed => '设备信息更新失败。';

  @override
  String get aboutTitle => '关于';

  @override
  String get aboutDescription => 'StatusInsights 版本 1.0.0，基于 Flutter 构建。';

  @override
  String get aboutNoteProject => '本项目用于状态洞察与信息展示。';

  @override
  String get aboutNoteFuture => '后续将持续补充更多设置项与功能模块。';

  @override
  String get androidUsagePermissionTitle => '授权提示';

  @override
  String get androidUsagePermissionMessage => '请授予“使用情况访问权限”，否则无法获取其他应用的前台应用名。';

  @override
  String get androidUsagePermissionAction => '前往授权';
}
