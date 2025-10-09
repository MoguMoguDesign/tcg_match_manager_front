import 'package:domain/src/auth/auth_repository.dart';
import 'package:domain/src/auth/auth_user.dart';
import 'package:domain/src/auth/sign_in_with_email_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_with_email_use_case_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('SignInWithEmailUseCase', () {
    late MockAuthRepository mockRepository;
    late SignInWithEmailUseCase useCase;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = SignInWithEmailUseCase(mockRepository);
    });

    group('call', () {
      const email = 'test@example.com';
      const password = 'password123';

      test('正常にサインインできる', () async {
        // Arrange
        const expectedUser = AuthUser(
          uid: 'test-uid',
          email: email,
          emailVerified: true,
        );
        when(
          mockRepository.signInWithEmail(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => expectedUser);

        // Act
        final result = await useCase.call(email: email, password: password);

        // Assert
        expect(result, equals(expectedUser));
        verify(
          mockRepository.signInWithEmail(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test('メールアドレスが空の場合、ArgumentErrorをthrowする', () async {
        // Act & Assert
        expect(
          () => useCase.call(email: '', password: password),
          throwsA(isA<ArgumentError>()),
        );
        verifyNever(
          mockRepository.signInWithEmail(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        );
      });

      test('メールアドレスが空白のみの場合、ArgumentErrorをthrowする', () async {
        // Act & Assert
        expect(
          () => useCase.call(email: '   ', password: password),
          throwsA(isA<ArgumentError>()),
        );
        verifyNever(
          mockRepository.signInWithEmail(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        );
      });

      test('パスワードが空の場合、ArgumentErrorをthrowする', () async {
        // Act & Assert
        expect(
          () => useCase.call(email: email, password: ''),
          throwsA(isA<ArgumentError>()),
        );
        verifyNever(
          mockRepository.signInWithEmail(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        );
      });

      test('パスワードが空白のみの場合、ArgumentErrorをthrowする', () async {
        // Act & Assert
        expect(
          () => useCase.call(email: email, password: '   '),
          throwsA(isA<ArgumentError>()),
        );
        verifyNever(
          mockRepository.signInWithEmail(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        );
      });

      test('リポジトリがAuthExceptionをthrowした場合、そのまま伝播する', () async {
        // Arrange
        when(
          mockRepository.signInWithEmail(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(
          const AuthException(
            code: 'INVALID_CREDENTIALS',
            message: 'メールアドレスまたはパスワードが正しくありません',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.call(email: email, password: password),
          throwsA(
            isA<AuthException>().having(
              (e) => e.code,
              'code',
              'INVALID_CREDENTIALS',
            ),
          ),
        );
      });
    });
  });
}
