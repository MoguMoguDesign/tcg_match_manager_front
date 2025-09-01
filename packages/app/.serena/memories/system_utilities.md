# システムユーティリティ（macOS）

## 基本コマンド
```bash
# ディレクトリ操作
ls -la          # ファイル一覧（詳細表示）
cd path/to/dir  # ディレクトリ移動
pwd             # 現在のディレクトリ表示
mkdir dirname   # ディレクトリ作成
rm -rf dirname  # ディレクトリ削除

# ファイル操作
cat filename    # ファイル内容表示
head -n 20 file # ファイル先頭20行表示
tail -n 20 file # ファイル末尾20行表示
find . -name "*.dart" # Dartファイル検索
```

## Git操作
```bash
git status              # 状態確認
git add .              # すべての変更をステージング
git commit -m "message" # コミット
git push origin branch  # プッシュ
git pull origin branch  # プル
git log --oneline      # コミット履歴（簡潔）
```

## 検索・フィルタリング
```bash
# パターン検索
grep -r "pattern" .     # 再帰的検索
grep -n "pattern" file  # 行番号付き検索

# パッケージ内検索
find packages/ -name "*.dart" -exec grep -l "RankingPlayer" {} \;

# プロセス確認
ps aux | grep flutter   # Flutterプロセス確認
```

## 開発環境固有
```bash
# FVMコマンド
fvm list               # インストール済みFlutterバージョン
fvm use stable         # プロジェクト用バージョン設定
fvm global stable      # グローバル設定

# Flutter/Dart
fvm flutter doctor     # Flutter環境確認
fvm flutter devices    # 利用可能デバイス
fvm dart --version     # Dartバージョン確認

# ポート確認・プロセス管理
lsof -i :8080         # ポート8080使用プロセス確認
kill -9 PID           # プロセス強制終了
```

## ファイルシステム
```bash
# 権限確認・変更
ls -la filename        # ファイル権限確認
chmod 755 filename     # 権限変更

# ディスク使用量
du -sh directory/      # ディレクトリサイズ
df -h                  # ディスク使用状況
```

## 便利なエイリアス（推奨）
```bash
# ~/.zshrc に追加推奨
alias melos='fvm dart run melos'
alias flutter='fvm flutter'
alias dart='fvm dart'
```