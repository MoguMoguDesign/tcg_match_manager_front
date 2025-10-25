import 'dart:convert';
import 'dart:io';

import 'package:firedart/firedart.dart';

/// Firebase の初期化を行う。
class FirebaseInitializer {
  /// Firebase を初期化する。
  ///
  /// [projectId] Firebase プロジェクト ID。
  /// [serviceAccountPath] サービスアカウントキーファイルのパス。
  /// [useEmulator] エミュレータを使用するかどうか。
  /// [emulatorHost] エミュレータのホスト（useEmulator=true の場合のみ）。
  ///
  /// 戻り値: 初期化された Firestore インスタンス。
  ///
  /// 注意: firedart はサービスアカウント認証に完全対応していないため、
  /// 現在は認証なしで Firestore に接続します。
  /// 本番環境で使用する場合は、Firestore のセキュリティルールを適切に設定してください。
  static Future<Firestore> initialize({
    required String projectId,
    required String serviceAccountPath,
    bool useEmulator = false,
    String? emulatorHost,
  }) async {
    // サービスアカウントキーを読み込み（将来の拡張のため）
    final keyFile = File(serviceAccountPath);
    final keyJson = await keyFile.readAsString();
    final keyData = json.decode(keyJson) as Map<String, dynamic>;

    // サービスアカウント情報を保持（ログ出力用）
    final serviceAccount = ServiceAccount.fromJson(keyData);

    // Firestore を初期化
    Firestore firestore;

    if (useEmulator) {
      // エミュレータ使用時
      if (emulatorHost == null) {
        throw ArgumentError('エミュレータホストが指定されていません');
      }

      // エミュレータでは認証不要
      // TODO: firedart でのエミュレータ接続方法を実装
      throw UnimplementedError(
        'エミュレータモードは現在未実装です。\n'
        'firedart パッケージがエミュレータに完全対応していないため、\n'
        '代替手段（REST API 直接使用など）を検討する必要があります。',
      );
    } else {
      // 本番環境／開発環境
      // TODO: サービスアカウント認証の実装
      // 現時点では firedart はサービスアカウント認証に完全対応していないため、
      // 認証なしで接続（開発環境でのみ使用可能）
      //
      // 本番環境で使用する場合は、以下のいずれかの対応が必要：
      // 1. Firestore セキュリティルールで特定の条件下でのみアクセス許可
      // 2. REST API を直接使用してサービスアカウント認証を実装
      // 3. 別の Dart Firestore クライアントライブラリを探す

      firestore = Firestore(projectId);

      // ログ出力（使用しているサービスアカウント情報）
      print('INFO: サービスアカウント: ${serviceAccount.clientEmail}');
      print('WARN: firedart はサービスアカウント認証に未対応のため、');
      print('WARN: 認証なしで Firestore に接続します。');
      print('WARN: Firestore セキュリティルールを適切に設定してください。');
    }

    return firestore;
  }

  /// Firestore 接続をクローズする。
  static Future<void> close() async {
    // firedart は明示的なクローズは不要
    // HTTP クライアントは自動的にクリーンアップされる
  }
}

/// サービスアカウント情報を保持する。
class ServiceAccount {
  const ServiceAccount({
    required this.type,
    required this.projectId,
    required this.privateKeyId,
    required this.privateKey,
    required this.clientEmail,
    required this.clientId,
    required this.authUri,
    required this.tokenUri,
    required this.authProviderCertUrl,
    required this.clientCertUrl,
  });

  factory ServiceAccount.fromJson(Map<String, dynamic> json) {
    return ServiceAccount(
      type: json['type'] as String,
      projectId: json['project_id'] as String,
      privateKeyId: json['private_key_id'] as String,
      privateKey: json['private_key'] as String,
      clientEmail: json['client_email'] as String,
      clientId: json['client_id'] as String,
      authUri: json['auth_uri'] as String,
      tokenUri: json['token_uri'] as String,
      authProviderCertUrl: json['auth_provider_x509_cert_url'] as String,
      clientCertUrl: json['client_x509_cert_url'] as String,
    );
  }

  final String type;
  final String projectId;
  final String privateKeyId;
  final String privateKey;
  final String clientEmail;
  final String clientId;
  final String authUri;
  final String tokenUri;
  final String authProviderCertUrl;
  final String clientCertUrl;

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'project_id': projectId,
      'private_key_id': privateKeyId,
      'private_key': privateKey,
      'client_email': clientEmail,
      'client_id': clientId,
      'auth_uri': authUri,
      'token_uri': tokenUri,
      'auth_provider_x509_cert_url': authProviderCertUrl,
      'client_x509_cert_url': clientCertUrl,
    };
  }
}
