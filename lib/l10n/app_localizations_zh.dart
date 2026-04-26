import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'StatusInsights 客户端';

  @override
  String get settings => '设置';

  @override
  String get serverAddress => '服务器地址';

  @override
  String get serverAddressHint => 'https://your-server.example.com';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get deviceInfo => '设备信息';

  @override
  String get deviceGuid => '设备 GUID';

  @override
  String get deviceName => '设备名称';

  @override
  String get deviceType => '设备类型';

  @override
  String get deviceStatus => '设备状态';

  @override
  String get notRegistered => '未注册';

  @override
  String get registered => '已注册';

  @override
  String get registerDevice => '注册设备';

  @override
  String get unregisterDevice => '取消注册';

  @override
  String get autoReporting => '自动上报';

  @override
  String get autoReportingOn => '自动上报已开启';

  @override
  String get autoReportingOff => '自动上报已停止';

  @override
  String get startReporting => '开始上报';

  @override
  String get stopReporting => '停止上报';

  @override
  String get currentWindowTitle => '当前窗口';

  @override
  String get noneDetected => '未检测到';

  @override
  String get customStatus => '自定义状态';

  @override
  String get personStatus => '个人状态';

  @override
  String get personStatusHint => '如：工作中、开会中、休息中……';

  @override
  String get submitStatus => '提交状态';

  @override
  String get lastReported => '上次上报';

  @override
  String get never => '从未';

  @override
  String get errorServerNotSet => '服务器地址未配置';

  @override
  String get errorNotRegistered => '设备未注册';

  @override
  String get successRegistered => '设备注册成功';

  @override
  String get successUnregistered => '设备取消注册成功';

  @override
  String get successStatusSubmitted => '状态提交成功';

  @override
  String errorFailed(String message) => '操作失败：$message';

  @override
  String get copied => '已复制到剪贴板';

  @override
  String get serverSettings => '服务器设置';

  @override
  String get aboutApp => '关于';

  @override
  String get version => '版本';

  @override
  String get reportingInterval => '上报间隔：每 20 秒';

  @override
  String get noWindowTitle => '未检测到窗口';

  @override
  String get tapToCopy => '点击复制';

  @override
  String get serverAddressUpdated => '服务器地址已更新';

  @override
  String get confirmUnregister => '确认取消注册';

  @override
  String get confirmUnregisterMessage => '确定要取消注册此设备吗？之后可以重新注册。';

  @override
  String get confirm => '确认';

  @override
  String get statusHistory => '状态历史';

  @override
  String get language => '语言';
}
