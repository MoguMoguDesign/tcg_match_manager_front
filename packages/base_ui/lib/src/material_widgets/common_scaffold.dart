import 'package:flutter/material.dart';

/// アプリ内で共通で用いられる [Scaffold].
class CommonScaffold extends StatelessWidget {
  /// [CommonScaffold] を生成する。
  ///
  /// [appbarTitle] 又は [appbarText] のどちらか一方を指定する必要がある。
  factory CommonScaffold({
    Key? key,
    String? appbarText,
    Widget? appbarTitle,
    List<Widget>? actions,
    required Widget body,
    Widget? bottomNavigationBar,
    bool enableScrollView = true,
    bool enableHorizontalPadding = true,
  }) {
    _validateAppBarTitle(appbarText, appbarTitle);
    return CommonScaffold._(
      key: key,
      appbarText: appbarText,
      appbarTitle: appbarTitle,
      actions: actions,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      enableScrollView: enableScrollView,
      enableHorizontalPadding: enableHorizontalPadding,
    );
  }

  /// スクロール可能なコンテンツ(GridView、ListView など)用に [CommonScaffold] を生成する。
  ///
  /// 内部的には SingleChildScrollView を無効化し、
  /// GridView や ListView などのスクロール可能なウィジェットが
  /// 自身のスクロール機能を利用できるようにする。
  ///
  /// [appbarTitle] 又は [appbarText] のどちらか一方を指定する必要がある。
  factory CommonScaffold.scrollable({
    Key? key,
    String? appbarText,
    Widget? appbarTitle,
    List<Widget>? actions,
    required Widget body,
    Widget? bottomNavigationBar,
    bool enableHorizontalPadding = true,
  }) {
    _validateAppBarTitle(appbarText, appbarTitle);
    return CommonScaffold._(
      key: key,
      appbarText: appbarText,
      appbarTitle: appbarTitle,
      actions: actions,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      enableScrollView: false,
      enableHorizontalPadding: enableHorizontalPadding,
    );
  }

  const CommonScaffold._({
    super.key,
    this.appbarText,
    this.appbarTitle,
    this.actions,
    required this.body,
    this.bottomNavigationBar,
    this.enableScrollView = true,
    this.enableHorizontalPadding = true,
  });

  /// [AppBar] のタイトル指定のバリデーションを行う。
  static void _validateAppBarTitle(String? appbarText, Widget? appbarTitle) {
    assert(
      (appbarText != null) != (appbarTitle != null),
      'One of appbarText or appbarTitle must be provided.',
    );
  }

  /// [AppBar] のタイトルとなるウィジェット。
  final Widget? appbarTitle;

  /// [AppBar] のタイトル用文字列。
  final String? appbarText;

  /// [AppBar] の右側に配置されるウィジェットの配列。
  final List<Widget>? actions;

  /// [Scaffold.body] へ設定される、本体となるウィジェット。
  ///
  /// 上下左右へ共通の余白を持たせている。
  final Widget body;

  /// ボトムナビゲーションバー。
  final Widget? bottomNavigationBar;

  /// スクロールビューを有効にするかどうか。
  ///
  /// false の場合、SingleChildScrollView を使用せず、
  /// GridView や ListView などのスクロール可能なウィジェットを直接配置できる。
  final bool enableScrollView;

  /// 水平方向のパディングを有効にするかどうか。
  final bool enableHorizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: appbarTitle ?? Text(appbarText!),
        actions: actions,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: enableHorizontalPadding ? 16 : 0,
            vertical: 8,
          ),
          child: enableScrollView ? SingleChildScrollView(child: body) : body,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
