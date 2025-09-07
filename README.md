# flutter_monorepo_sample

[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

## 環境構築

### 開発環境

本リポジトリは以下の開発環境を前提としています。

- 対応 OS: macOS / Windows
- IDE: Visual Studio Code

### 1. セットアップコマンドの実行

本リポジトリをクローン後、プロジェクトルートへ移動して以下のコマンドを実行してください。

※ macOS の場合は [Homebrew](https://www.kikagaku.co.jp/kikagaku-blog/homebrew-install-howto/)、Windows の場合は [Chocolatey](https://qiita.com/Soysoy11110000/items/925391c57d01a3e3ffd8) のインストールが事前に必要です。

macOS の場合：

```shell
make setup-macos
```

Windows の場合：

```shell
make setup-windows
```

これにより、FVM や Melos のような開発に必要なツールがインストールされます。

※ コマンドを実行した際に PATH を通すように warning が出ている場合、指示に沿ってシェルの設定ファイル(eg. `~/.zshrc`)へ記述してください。

#### 補足）FVM について

本プロジェクトは Flutter のバージョン管理に [FVM](https://fvm.app/) を利用しています。上記のセットアップコマンドにより、FVM のインストール及びバージョン指定を行っています。

`flutter` や `dart` コマンドの実行時には、冒頭に `fvm` をつけてプロジェクトで共通のバージョンを利用するようにしてください。尚、現在は `stable` 版指定となっているため、 `fvm flutter upgrade` にて各自が定期的に最新の stable バージョンへアップグレードする必要があります。

### 2. Flutter SDK の設定

上述のように本プロジェクトでは FVM を利用していますが、通常の `flutter` コマンドもこの FVM を利用した設定を行います。詳細は[こちら](https://zenn.dev/altiveinc/articles/flutter-version-management#global-を使えばどこでも-flutter-コマンドが使用できる)。

まず、以下のコマンドを任意のディレクトリで実行してください：

```shell
fvm global stable
```

※ 過去に[公式ドキュメントが紹介する方法](https://docs.flutter.dev/get-started/install/macos/mobile-ios#download-the-flutter-sdk)で Flutter SDK を既にインストールしている場合、競合を避けるために削除してください。

次に、上記の global の Flutter SDK への PATH を通します。

各自の環境におけるシェルの設定ファイル(masOS の場合は `~/.zshrc`)へ以下を記載してください：

```.zshrc
export PATH="$PATH:$HOME/fvm/default/bin"
```

以下のコマンドにより、実際に PATH が通っていることを確認します：

```shell
which flutter # /Users/${ユーザー名}/fvm/default/bin/flutter
```

### 3. ビルド環境の用意

Flutter の利用が初めての場合、以下のドキュメントに沿ってビルド環境を構築してください。

macOS の場合(iOS 及び Android):
https://docs.flutter.dev/get-started/install/macos

Windows の場合(Android):
https://docs.flutter.dev/get-started/install/windows

#### Flutter SDK について

ドキュメント内で指示される [Flutter SDK のインストール](https://docs.flutter.dev/get-started/install/macos/mobile-ios#install-the-flutter-sdk) は既に前のステップで FVM の global コマンドを利用した形で行なっているため、不要です。

#### cocoapods のインストールについて

iOS における [CocoaPods のインストール](https://docs.flutter.dev/get-started/install/macos/mobile-ios#install-cocoapods)のステップにて `sudo gem install cocoapods` コマンドが成功しない場合（or インストール後に `flutter doctor` により CocoaPods 関連のエラーが発生している場合）、インストール時にシステムに元々入っている Ruby を利用しており、そのバージョンが適切でない可能性があります。このような場合、以下の手順に沿って [rbenv](https://github.com/rbenv/rbenv) により新しいバージョンの Ruby を CocoaPods のインストールに利用するように設定します([参考](https://guides.cocoapods.org/using/getting-started.html#getting-started))。

###### 1. CocoaPods のアンインストール

既に不適切な CocoaPods が入ってしまっている場合には以下を実行します：

```shell
sudo gem uninstall cocoapods
```

###### 2. rbenv のインストール

Homebrew を利用して rbenv インストールします：

```shell
brew install ruby-build rbenv
```

シェルの設定ファイル(`~/.zshrc`)へ以下の 2 行を追加してください：

```.zshrc
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"
```

現在開いているターミナルへ変更を反映します：

```shell
source ~/.zshrc
```

###### 3. Ruby のバージョンアップ

インストール可能なバージョン一覧を確認します：

```shell
rbenv install -l
```

一覧にあった最新バージョンをインストールします：

```shell
rbenv install x.y.z
```

インストールした Ruby のバージョンをシェル全体で適用するように設定します：

```shell
rbenv global x.y.z
```

設定を反映します：

```shell
rbenv init
```

rbenv の gem が動くか確認します：

```shell
which gem
# (○) 適切に反映されている場合：
# /Users/${ユーザー名}/.rbenv/shims/gem
# (×) システムの gem が参照されてしまっている場合：
# usr/bin/gem
```

###### 4. CocoaPods のインストール

以下コマンドで再度 CocoaPods をインストールします：

```shell
sudo gem install cocoapods
```

## VS Code の拡張機能について

本アプリのビルド環境である VS Code においては以下の拡張機能を利用すると開発効率が向上するため、適宜インストールしてご利用ください。

### テストカバレッジ計測

注意） Windows 環境においては現時点では非対応です。

1.  `melos run test` の実行

最新のカバレッジを反映します。レポートは各パッケージの `coverage` ディレクトリの中に格納されます。

2. ファイル単位でのカバレッジの確認

[Flutter Coverage](https://marketplace.visualstudio.com/items?itemName=Flutterando.flutter-coverage) により、ファイル単位でのカバレッジを確認することが出来ます。

参考記事：https://codewithandrea.com/articles/flutter-test-coverage/#the-flutter-coverage-extension

3. 行単位でのカバレッジの確認

[Coverage Gutters](https://marketplace.visualstudio.com/items?itemName=ryanluker.vscode-coverage-gutters) により、ファイル内でカバーされていない行を確認することが出来ます。

参考記事：https://codewithandrea.com/articles/flutter-test-coverage/#the-coverage-gutters-extension

## Melos について

本プロジェクトではパッケージ管理に [melos | Dart Package](https://pub.dev/packages/melos) 及び [Pub workspaces](https://dart.dev/tools/pub/workspaces) を導入しています。

利用方法等の詳細は以下の記事をご覧下さい。

Melos について：https://zenn.dev/altiveinc/articles/melos-for-managing-dart-projects

Pub workspaces について：https://zenn.dev/kosukesaigusa/articles/dart-pub-workspaces

尚、melos コマンドを利用する際には、ローカル環境での Dart バージョンは pubspec.yaml の `environment` に指定されているバージョン以上である必要があります。上述の 「2. Flutter SDK の設定」 を行なっている場合には問題ありませんが、そのような管理が難しい場合には`fvm dart run melos bs` のように冒頭に `fvm dart run` をつけて都度実行する必要があります。

## ドキュメンテーション について

本プロジェクトでは、Lint ルールとして [public_member_api_docs](https://dart.dev/tools/linter-rules/public_member_api_docs) を採用しています。

これにより、全てのパブリックメンバー(クラス、メソッド、関数、変数)には、適切なドキュメンテーションコメントが必要となります。

詳細な書き方は実際のソースコードや[こちらの記事](https://zenn.dev/team_soda/articles/dart-documentation)をご参照ください。

## 多言語対応について

本アプリは日本語/英語に対応しているため、Text ウィジェット内で文字列を表示する際にはハードコーディングする代わりに翻訳用のファイル(`l10n.dart`)へ定義されたものを利用する必要があります。以下の手順に沿って翻訳用のフィールドを追加・利用してください。

### 1. 翻訳用フィールドの追加

日本語用のフィールドを `app_ja.arb` へ追加してください。

尚、arb キーの命名規則は、「利用用途 → 内容」の順でキャメルケースで記載する方針としています。

例）

```arb
"labelFoo": "ラベル用文字列 Foo"
"buttonFoo": "ボタン用文字列 Foo"
"dialogFoo": "ダイアログ用文字列 Foo"
"messageFoo": "メッセージ用文字列 Foo"
"appBarFoo": "AppBar 用文字列 Foo"
"placeholderFoo": "プレースホルダー用文字列 Foo"
"fooTypeBar": "FooType enum 用文字列の値 Bar"
```

### 2. 翻訳用コマンドの実行

`melos run translate` コマンドを実行してください。

本プロジェクトでは翻訳の効率化のために [arb_translate](https://pub.dev/packages/arb_translate) を利用しており（[参考](https://zenn.dev/masa_tokyo/articles/arb_translate)）、デフォルト言語の日本語用のフィールドを追加することでその他言語（英語）への翻訳が行えるようになっています。上記の melos コマンドにより、`arb_translate` コマンドの実行や、その後の翻訳用のファイルへの反映を行なっています。

### 3. 翻訳用フィールドの利用

`L10n.of(context).labelFoo` のようにすることで、各デバイスの言語設定に応じた文字列が取得出来ます。

## ドキュメント（docs サブモジュール）

本リポジトリのルート直下に、設計ドキュメント群を格納したサブモジュール `docs/` を追加しています。

- リポジトリ: `https://github.com/MoguMoguDesign/tcg_match_manager_docs`
- 配置先: ルート直下の `docs/`
- 親リポジトリ側の設定: `.gitmodules` に `ignore = dirty` を設定済み、`.gitignore` に `/docs/` を追加済み。

### 初回セットアップ（クローン直後）

```shell
git submodule update --init --recursive
```

### ドキュメント（サブモジュール）の更新取得

```shell
# サブモジュールの最新を取得
git submodule update --remote --merge docs

# 取得したコミットを親リポジトリに反映（必要な場合）
git add docs
git commit -m "chore: bump docs submodule"
```

### ドキュメントを編集・反映する場合

```shell
# サブモジュール側で編集・コミット・プッシュ
cd docs
git checkout -b feat/update-spec
# （編集）
git add . && git commit -m "docs: update specifications"
git push origin feat/update-spec

# レビュー・マージ後、親側でサブモジュール参照を更新
cd ..
git submodule update --remote --merge docs
git add docs && git commit -m "chore: bump docs submodule"
```

補足: 親リポジトリでは `.gitmodules` の `ignore = dirty` により、`docs/` 内の未コミット変更はステータス上無視されます。サブモジュールの変更を親に反映したい場合は、`docs` 内でコミット・プッシュを行い、その後に親でサブモジュール参照を更新してください。
