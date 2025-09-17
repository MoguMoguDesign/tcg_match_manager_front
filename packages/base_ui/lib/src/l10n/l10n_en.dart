// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appBarLogin => 'Add Bookshelf Account';

  @override
  String get buttonLogin => 'Login';

  @override
  String get labelCancel => 'Cancel';

  @override
  String get labelErrorCode => 'Error Code:';

  @override
  String get labelGuest => 'Guest';

  @override
  String get labelHome => 'Home';

  @override
  String get labelInfo => 'Info';

  @override
  String get labelOkay => 'OK';

  @override
  String get labelPassword => 'Password';

  @override
  String get labelRefresh => 'Refresh';

  @override
  String get labelSearch => 'Search';

  @override
  String get labelServer => 'Server';

  @override
  String get labelSettings => 'Settings';

  @override
  String get labelUserName => 'User Name';

  @override
  String get messageEmpty => 'This field is required.';

  @override
  String get messageNoConnectionError =>
      'Please check your network connection.';

  @override
  String get messageOtherError =>
      'An error has occurred. Please contact support.';

  @override
  String get messageServerUrlNotFoundError =>
      'Verify that the server URL is correct.';

  @override
  String get messageInvalidTextInput => 'Invalid input.';

  @override
  String get titleLoginFailed => 'Login failed';

  @override
  String rankNumberLabel(int n) => '#$n';
}
