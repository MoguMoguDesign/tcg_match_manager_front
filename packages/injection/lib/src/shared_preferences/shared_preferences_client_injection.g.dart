// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_preferences_client_injection.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesClientHash() =>
    r'703eb47e1160ba9b46e9327b2bf7f041f11b7c3c';

/// [SharedPreferencesClient] を生成する。
///
/// アプリやテストの起動時に環境に応じて適切な [SharedPreferencesClient] を注入して使用される。
///
/// Copied from [sharedPreferencesClient].
@ProviderFor(sharedPreferencesClient)
final sharedPreferencesClientProvider =
    Provider<SharedPreferencesClient>.internal(
      sharedPreferencesClient,
      name: r'sharedPreferencesClientProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sharedPreferencesClientHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesClientRef = ProviderRef<SharedPreferencesClient>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
