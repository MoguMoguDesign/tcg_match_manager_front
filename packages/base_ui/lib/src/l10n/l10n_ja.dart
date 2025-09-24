// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get appBarLogin => 'ログイン';

  @override
  String get buttonLogin => 'ログイン';

  @override
  String get labelCancel => 'キャンセル';

  @override
  String get labelErrorCode => 'エラーコード：';

  @override
  String get labelGuest => 'ゲスト';

  @override
  String get labelHome => 'ホーム';

  @override
  String get labelInfo => 'インフォ';

  @override
  String get labelOkay => 'OK';

  @override
  String get labelPassword => 'パスワード';

  @override
  String get labelRefresh => '更新';

  @override
  String get labelSearch => '検索';

  @override
  String get labelServer => 'サーバー';

  @override
  String get labelSettings => '設定';

  @override
  String get labelUserName => 'ユーザー名';

  @override
  String get messageEmpty => '未入力です。';

  @override
  String get messageNoConnectionError => 'ネットワーク接続を確認してください。';

  @override
  String get messageOtherError => 'エラーが発生しました。運営へお問い合わせください。';

  @override
  String get messageServerUrlNotFoundError => 'サーバー URL が正しいかご確認ください。';

  @override
  String get messageInvalidTextInput => '入力欄に誤りがあります。';

  @override
  String get titleLoginFailed => 'ログインに失敗しました';
}
