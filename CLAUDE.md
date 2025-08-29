# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリのコードを扱う際のガイダンスを提供します。

## ⚠️ 必須: 実装前チェックリスト

**コード実装を開始する前に、必ず以下を確認してください:**
- [ ] CLAUDE.md を読み込み、作業内容に応じた適切な Cursor ルールファイルを特定した
- [ ] **必ず全ての「常に適用されるルール (alwaysApply: true)」を読み込んだ**
- [ ] 作業内容に応じた「パッケージ固有のルール」を読み込んだ
- [ ] 読み込んだ全てのルールファイルの要求事項を理解した

## Cursor ルールの参照

プロジェクトでは Cursor IDE 用の詳細なルールが `.cursor/rules` ディレクトリに定義されています。
これらのルールを場面に応じて適用してください。

### 常に適用されるルール (alwaysApply: true)

**⚠️ 重要: 以下の4つのルールファイルは、どんなタスクであっても必ず全て読み込んでください。1つでもスキップすると正しく動作しません。**

1. `/project.mdc` - プロジェクトの概要やアーキテクチャについて
2. `/operations/before-implementation.mdc` - 実装前の準備とファイル識別  
3. `/operations/after-implementation.mdc` - 実装後の検証とテスト実行
4. `/coding-rules/documentation.mdc` - 日本語ドキュメント標準

### パッケージ固有のルール
各パッケージには専用の実装およびテストルールが定義されています。
場面に応じて以下を参照してください：

#### App パッケージ
- `/coding-rules/app/app-implementation.mdc` - アプリケーションレイヤーの実装ルール

#### Domain パッケージ
- `/coding-rules/domain/domain-implementation.mdc` - ドメインレイヤーの実装パターン
- `/coding-rules/domain/domain-test.mdc` - ドメインレイヤーのテスト標準（100% カバレッジ）

#### Repository パッケージ
- `/coding-rules/repository/repository-implementation.mdc` - リポジトリレイヤーの実装パターン
- `/coding-rules/repository/repository-test.mdc` - リポジトリレイヤーのテスト標準（100% カバレッジ）

#### System パッケージ
- `/coding-rules/system/system-implementation.mdc` - システムレイヤー（サードパーティーラッパー）の実装
- `/coding-rules/system/system-test.mdc` - システムレイヤーのテスト標準（100% カバレッジ）

#### Injection パッケージ
- `/coding-rules/injection/injection-implementation.mdc` - 依存性注入の実装パターン
- `/coding-rules/injection/injection-test.mdc` - 依存性注入のテスト標準（100% カバレッジ）

#### Util パッケージ
- `/coding-rules/util/util-implementation.mdc` - ユーティリティパッケージの実装（純粋な Dart）
- `/coding-rules/util/util-test.mdc` - ユーティリティパッケージのテスト標準（100% カバレッジ）