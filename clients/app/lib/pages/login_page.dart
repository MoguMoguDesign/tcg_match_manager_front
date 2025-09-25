import 'package:base_ui/base_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// MEMO(masaki): 動的な挙動をここに書くか検討（静的なテンプレートの役割とファイルを分ける運用にすればベターかもしれない）
/// ログインページ。
///
/// ログインボタンの押下時、バリデーション（サーバー URL とユーザー名が空文字の場合）を行い、適切な場合はログイン処理を行う。
/// 失敗時には、エラーダイアログを表示する。
class LoginPage extends HookConsumerWidget {
  /// [LoginPage] を生成する。
  const LoginPage({super.key});

  /// フォームのバリデーションを管理するための [GlobalKey].
  static final _formKey = GlobalKey<FormState>();

  /// ウィジェットテストにて用いる、サーバー URL の [TextFormField] のキー。
  static const serverUrlTextFieldKey = Key('serverUrlTextField');

  /// ウィジェットテストにて用いる、ユーザー名の [TextFormField] のキー。
  static const userNameTextFieldKey = Key('userNameTextField');

  /// ウィジェットテストにて用いる、パスワードの [TextFormField] のキー。
  static const passwordTextFieldKey = Key('passwordTextField');

  /// 入力が空の場合にエラーメッセージを返す。
  String? _validateEmptyInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '未入力です。';
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverUrlController = useTextEditingController(text: '');
    final userNameController = useTextEditingController(text: '');
    final passwordController = useTextEditingController(text: '');
    final isGuest = useState(false);

    // MEMO(masaki): 以下のデフォルトのものを全体で調整する
    // https://m3.material.io/styles/typography/type-scale-tokens
    final textTheme = Theme.of(context).textTheme;

    return CommonScaffold(
      appbarText: 'ログイン',
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text('Login', style: textTheme.titleLarge)),
            const Gap(12),
            const Text('サーバー'),
            CommonTextField.withIcon(
              key: serverUrlTextFieldKey,
              icon: Icons.cloud,
              controller: serverUrlController,
              onChanged: (value) {},
              validator: _validateEmptyInput,
            ),
            const Gap(12),
            const Text('ゲスト'),
            CommonSwitch(
              value: isGuest.value,
              onChanged: (newValue) {
                isGuest.value = newValue;
              },
            ),
            const Gap(12),
            const Text('ユーザー名'),
            CommonTextField.withIcon(
              key: userNameTextFieldKey,
              icon: Icons.account_box_rounded,
              controller: userNameController,
              onChanged: (value) {},
              validator: _validateEmptyInput,
            ),
            const Gap(12),
            const Text('パスワード'),
            CommonTextField.withIcon(
              key: passwordTextFieldKey,
              icon: Icons.lock_outline,
              controller: passwordController,
              onChanged: (value) {},
            ),
            const Gap(16),
            Align(
              alignment: Alignment.centerRight,
              child: CommonElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    await CommonAlertDialog.show(
                      context,
                      contentString: '入力欄に誤りがあります。',
                    );
                    return;
                  }
                  try {
                    final account = await ref
                        .read(loginUseCaseProvider)
                        .invoke(
                          serverUrl: serverUrlController.text,
                          userName: userNameController.text,
                          password: passwordController.text,
                          isManualLogin: true,
                          isGuest: isGuest.value,
                        );
                    // MEMO(masaki): 暫定的に結果を表示
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          // MEMO(masaki): 実際には不要な文字列なので日本語になっている
                          // ignore: avoid_hardcoded_japanese
                          content: Text('ログインに成功しました: ${account.displayName}'),
                        ),
                      );
                    }
                  } on FailureStatusException catch (e) {
                    if (!context.mounted) {
                      return;
                    }
                    await CommonAlertDialog.show(
                      context,
                      titleString: 'ログインに失敗しました',
                      contentString: e.message,
                    );
                  } on GeneralFailureException catch (e) {
                    if (!context.mounted) {
                      return;
                    }
                    final statusCode = e.statusCode == null
                        ? ''
                        : e.statusCode.toString();
                    // エラーコードとメッセージを合わせて表示する
                    final errorMessage =
                        '''
              エラーコード： $statusCode ${e.errorCode}
              
              ${switch (e.reason) {
                          GeneralFailureReason.noConnectionError => 'ネットワーク接続を確認してください。',
                          GeneralFailureReason.serverUrlNotFoundError => 'サーバー URL が正しいかご確認ください。',
                          GeneralFailureReason.badResponse => 'エラーが発生しました。運営へお問い合わせください。',
                          GeneralFailureReason.other => 'エラーが発生しました。運営へお問い合わせください。',
                        }}''';

                    await CommonAlertDialog.show(
                      context,
                      titleString: 'ログインに失敗しました',
                      contentString: errorMessage,
                    );
                  }
                },
                child: const Text('ログイン'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
