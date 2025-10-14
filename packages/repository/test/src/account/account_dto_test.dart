import 'package:flutter_test/flutter_test.dart';
import 'package:repository/repository.dart';

void main() {
  group('AccountDto のテスト', () {
    group('コンストラクタのテスト', () {
      test('必須フィールドのみでインスタンスを作成できる', () {
        const dto = AccountDto(isFailureStatus: false);

        expect(dto.isFailureStatus, isFalse);
        expect(dto.sub, 0);
        expect(dto.message, '');
        expect(dto.userId, '');
        expect(dto.username, '');
        expect(dto.displayName, '');
        expect(dto.email, '');
        expect(dto.apiVersion, 1);
        expect(dto.accessToken, '');
        expect(dto.refreshToken, '');
        expect(dto.expiresAt, 0);
      });

      test('全てのフィールドを指定してインスタンスを作成できる', () {
        const dto = AccountDto(
          isFailureStatus: false,
          sub: 1,
          message: 'Success',
          userId: 'user-123',
          username: 'testuser',
          displayName: 'Test User',
          email: 'test@example.com',
          apiVersion: 2,
          accessToken: 'access-token-123',
          refreshToken: 'refresh-token-123',
          expiresAt: 1633046400,
        );

        expect(dto.isFailureStatus, isFalse);
        expect(dto.sub, 1);
        expect(dto.message, 'Success');
        expect(dto.userId, 'user-123');
        expect(dto.username, 'testuser');
        expect(dto.displayName, 'Test User');
        expect(dto.email, 'test@example.com');
        expect(dto.apiVersion, 2);
        expect(dto.accessToken, 'access-token-123');
        expect(dto.refreshToken, 'refresh-token-123');
        expect(dto.expiresAt, 1633046400);
      });

      test('isFailureStatus が true のインスタンスを作成できる', () {
        const dto = AccountDto(
          isFailureStatus: true,
          message: 'Error occurred',
        );

        expect(dto.isFailureStatus, isTrue);
        expect(dto.message, 'Error occurred');
      });
    });

    group('fromJson のテスト', () {
      test('必須フィールドのみのJSONから正常にインスタンスを生成できる', () {
        final json = {
          'STATUS': 0, // int型のステータスがboolに変換される
        };

        final dto = AccountDto.fromJson(json);

        expect(dto.isFailureStatus, isFalse);
        expect(dto.sub, 0);
        expect(dto.message, '');
      });

      test('全てのフィールドを含むJSONから正常にインスタンスを生成できる', () {
        final json = {
          'STATUS': 0,
          'SUB': 1,
          'MESSAGE': 'Success',
          'userId': 'user-123',
          'username': 'testuser',
          'displayName': 'Test User',
          'email': 'test@example.com',
          'apiVersion': 2,
          'accessToken': 'access-token-123',
          'refreshToken': 'refresh-token-123',
          'expiresAt': 1633046400,
        };

        final dto = AccountDto.fromJson(json);

        expect(dto.isFailureStatus, isFalse);
        expect(dto.sub, 1);
        expect(dto.message, 'Success');
        expect(dto.userId, 'user-123');
        expect(dto.username, 'testuser');
        expect(dto.displayName, 'Test User');
        expect(dto.email, 'test@example.com');
        expect(dto.apiVersion, 2);
        expect(dto.accessToken, 'access-token-123');
        expect(dto.refreshToken, 'refresh-token-123');
        expect(dto.expiresAt, 1633046400);
      });

      test('STATUS が 1 の場合、isFailureStatus が true になる', () {
        final json = {
          'STATUS': 1,
        };

        final dto = AccountDto.fromJson(json);

        expect(dto.isFailureStatus, isTrue);
      });

      test('STATUS が文字列 "0" の場合、isFailureStatus が false になる', () {
        final json = {
          'STATUS': '0',
        };

        final dto = AccountDto.fromJson(json);

        expect(dto.isFailureStatus, isFalse);
      });

      test('STATUS が文字列 "1" の場合、isFailureStatus が true になる', () {
        final json = {
          'STATUS': '1',
        };

        final dto = AccountDto.fromJson(json);

        expect(dto.isFailureStatus, isTrue);
      });
    });

    group('copyWith のテスト', () {
      test('isFailureStatus を更新できる', () {
        const dto = AccountDto(isFailureStatus: false);

        final updated = dto.copyWith(isFailureStatus: true);

        expect(updated.isFailureStatus, isTrue);
      });

      test('message を更新できる', () {
        const dto = AccountDto(
          isFailureStatus: false,
          message: 'Old message',
        );

        final updated = dto.copyWith(message: 'New message');

        expect(updated.message, 'New message');
        expect(updated.isFailureStatus, isFalse);
      });

      test('複数のフィールドを同時に更新できる', () {
        const dto = AccountDto(isFailureStatus: false);

        final updated = dto.copyWith(
          userId: 'user-123',
          username: 'testuser',
          email: 'test@example.com',
        );

        expect(updated.userId, 'user-123');
        expect(updated.username, 'testuser');
        expect(updated.email, 'test@example.com');
        expect(updated.isFailureStatus, isFalse);
      });
    });

    group('equality のテスト', () {
      test('同じ値を持つインスタンスは等しい', () {
        const dto1 = AccountDto(
          isFailureStatus: false,
          userId: 'user-123',
          username: 'testuser',
        );

        const dto2 = AccountDto(
          isFailureStatus: false,
          userId: 'user-123',
          username: 'testuser',
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('異なる値を持つインスタンスは等しくない', () {
        const dto1 = AccountDto(
          isFailureStatus: false,
          userId: 'user-123',
        );

        const dto2 = AccountDto(
          isFailureStatus: false,
          userId: 'user-456',
        );

        expect(dto1, isNot(equals(dto2)));
      });
    });
  });
}
