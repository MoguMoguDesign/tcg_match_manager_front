// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_api_client_injection.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminApiBaseUrlHash() => r'0d38c87a08b0e6074517bd91e3b752cd98eeb915';

/// Admin API のベースURLを提供する。
///
/// デフォルトではダミーURLだが、main.dartでオーバーライドされる。
///
/// Copied from [adminApiBaseUrl].
@ProviderFor(adminApiBaseUrl)
final adminApiBaseUrlProvider = AutoDisposeProvider<String>.internal(
  adminApiBaseUrl,
  name: r'adminApiBaseUrlProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminApiBaseUrlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminApiBaseUrlRef = AutoDisposeProviderRef<String>;
String _$adminApiClientHash() => r'e2b3681d3b081678d02b1ed1d7b9b4ff1c34af0a';

/// [AdminApiClient] を提供する。
///
/// Copied from [adminApiClient].
@ProviderFor(adminApiClient)
final adminApiClientProvider = AutoDisposeProvider<AdminApiClient>.internal(
  adminApiClient,
  name: r'adminApiClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminApiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminApiClientRef = AutoDisposeProviderRef<AdminApiClient>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
