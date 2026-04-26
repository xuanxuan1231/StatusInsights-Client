import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'StatusInsights クライアント';

  @override
  String get settings => '設定';

  @override
  String get serverAddress => 'サーバーアドレス';

  @override
  String get serverAddressHint => 'https://your-server.example.com';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get deviceInfo => 'デバイス情報';

  @override
  String get deviceGuid => 'デバイス GUID';

  @override
  String get deviceName => 'デバイス名';

  @override
  String get deviceType => 'デバイスタイプ';

  @override
  String get deviceStatus => 'デバイスステータス';

  @override
  String get notRegistered => '未登録';

  @override
  String get registered => '登録済み';

  @override
  String get registerDevice => 'デバイスを登録';

  @override
  String get unregisterDevice => '登録解除';

  @override
  String get autoReporting => '自動レポート';

  @override
  String get autoReportingOn => '自動レポートが有効です';

  @override
  String get autoReportingOff => '自動レポートが停止しています';

  @override
  String get startReporting => 'レポート開始';

  @override
  String get stopReporting => 'レポート停止';

  @override
  String get currentWindowTitle => '現在のウィンドウ';

  @override
  String get noneDetected => '検出されませんでした';

  @override
  String get customStatus => 'カスタムステータス';

  @override
  String get personStatus => '個人ステータス';

  @override
  String get personStatusHint => '例：作業中、会議中、休憩中…';

  @override
  String get submitStatus => 'ステータスを送信';

  @override
  String get lastReported => '最後のレポート';

  @override
  String get never => 'なし';

  @override
  String get errorServerNotSet => 'サーバーアドレスが設定されていません';

  @override
  String get errorNotRegistered => 'デバイスが登録されていません';

  @override
  String get successRegistered => 'デバイスが正常に登録されました';

  @override
  String get successUnregistered => 'デバイスの登録が解除されました';

  @override
  String get successStatusSubmitted => 'ステータスが送信されました';

  @override
  String errorFailed(String message) => '操作に失敗しました：$message';

  @override
  String get copied => 'クリップボードにコピーしました';

  @override
  String get serverSettings => 'サーバー設定';

  @override
  String get aboutApp => 'について';

  @override
  String get version => 'バージョン';

  @override
  String get reportingInterval => 'レポート間隔：20秒ごと';

  @override
  String get noWindowTitle => 'ウィンドウが検出されませんでした';

  @override
  String get tapToCopy => 'タップしてコピー';

  @override
  String get serverAddressUpdated => 'サーバーアドレスが更新されました';

  @override
  String get confirmUnregister => '登録解除の確認';

  @override
  String get confirmUnregisterMessage => 'このデバイスの登録を解除しますか？後で再登録できます。';

  @override
  String get confirm => '確認';

  @override
  String get statusHistory => 'ステータス履歴';

  @override
  String get language => '言語';
}
