import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
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
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

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
    Locale('ja'),
  ];

  /// No description provided for @appBarLogin.
  ///
  /// In ja, this message translates to:
  /// **'ログイン'**
  String get appBarLogin;

  /// No description provided for @buttonLogin.
  ///
  /// In ja, this message translates to:
  /// **'ログイン'**
  String get buttonLogin;

  /// No description provided for @labelCancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get labelCancel;

  /// No description provided for @labelErrorCode.
  ///
  /// In ja, this message translates to:
  /// **'エラーコード：'**
  String get labelErrorCode;

  /// No description provided for @labelGuest.
  ///
  /// In ja, this message translates to:
  /// **'ゲスト'**
  String get labelGuest;

  /// No description provided for @labelHome.
  ///
  /// In ja, this message translates to:
  /// **'ホーム'**
  String get labelHome;

  /// No description provided for @labelInfo.
  ///
  /// In ja, this message translates to:
  /// **'インフォ'**
  String get labelInfo;

  /// No description provided for @labelOkay.
  ///
  /// In ja, this message translates to:
  /// **'OK'**
  String get labelOkay;

  /// No description provided for @labelPassword.
  ///
  /// In ja, this message translates to:
  /// **'パスワード'**
  String get labelPassword;

  /// No description provided for @labelRefresh.
  ///
  /// In ja, this message translates to:
  /// **'更新'**
  String get labelRefresh;

  /// No description provided for @labelSearch.
  ///
  /// In ja, this message translates to:
  /// **'検索'**
  String get labelSearch;

  /// No description provided for @labelServer.
  ///
  /// In ja, this message translates to:
  /// **'サーバー'**
  String get labelServer;

  /// No description provided for @labelSettings.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get labelSettings;

  /// No description provided for @labelUserName.
  ///
  /// In ja, this message translates to:
  /// **'ユーザー名'**
  String get labelUserName;

  /// No description provided for @messageEmpty.
  ///
  /// In ja, this message translates to:
  /// **'未入力です。'**
  String get messageEmpty;

  /// No description provided for @messageNoConnectionError.
  ///
  /// In ja, this message translates to:
  /// **'ネットワーク接続を確認してください。'**
  String get messageNoConnectionError;

  /// No description provided for @messageOtherError.
  ///
  /// In ja, this message translates to:
  /// **'エラーが発生しました。運営へお問い合わせください。'**
  String get messageOtherError;

  /// No description provided for @messageServerUrlNotFoundError.
  ///
  /// In ja, this message translates to:
  /// **'サーバー URL が正しいかご確認ください。'**
  String get messageServerUrlNotFoundError;

  /// No description provided for @messageInvalidTextInput.
  ///
  /// In ja, this message translates to:
  /// **'入力欄に誤りがあります。'**
  String get messageInvalidTextInput;

  /// No description provided for @titleLoginFailed.
  ///
  /// In ja, this message translates to:
  /// **'ログインに失敗しました'**
  String get titleLoginFailed;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'ja':
      return L10nJa();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
