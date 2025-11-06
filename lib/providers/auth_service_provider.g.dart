// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authServiceHash() => r'7b1bbeef45ba0ed15efe89672fa658f6a30d769d';

/// See also [authService].
@ProviderFor(authService)
final authServiceProvider = AutoDisposeProvider<AuthService>.internal(
  authService,
  name: r'authServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authServiceHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthServiceRef = AutoDisposeProviderRef<AuthService>;
String _$authStateChangesHash() => r'93b22006a63c14cc0852e08eb6960c573e24e54e';

/// See also [authStateChanges].
@ProviderFor(authStateChanges)
final authStateChangesProvider = AutoDisposeStreamProvider<User?>.internal(
  authStateChanges,
  name: r'authStateChangesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateChangesHash,
  dependencies: <ProviderOrFamily>[authServiceProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    authServiceProvider,
    ...?authServiceProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateChangesRef = AutoDisposeStreamProviderRef<User?>;
String _$currentUserHash() => r'3cf24c4505901a8a266a4e4562c9fec5b49c23a7';

/// See also [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeProvider<UserModel?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserHash,
  dependencies: <ProviderOrFamily>[authStateChangesProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    authStateChangesProvider,
    ...?authStateChangesProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeProviderRef<UserModel?>;
String _$accessTokenHash() => r'93f9b0059376e2e90e6bfd911ed795300cfa16c8';

/// See also [accessToken].
@ProviderFor(accessToken)
final accessTokenProvider = AutoDisposeProvider<String?>.internal(
  accessToken,
  name: r'accessTokenProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accessTokenHash,
  dependencies: <ProviderOrFamily>[authServiceProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    authServiceProvider,
    ...?authServiceProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccessTokenRef = AutoDisposeProviderRef<String?>;
String _$idTokenHash() => r'1233adb6af923ff6b556bfa752b3410541f1b786';

/// See also [idToken].
@ProviderFor(idToken)
final idTokenProvider = AutoDisposeFutureProvider<String?>.internal(
  idToken,
  name: r'idTokenProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$idTokenHash,
  dependencies: <ProviderOrFamily>[authServiceProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    authServiceProvider,
    ...?authServiceProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IdTokenRef = AutoDisposeFutureProviderRef<String?>;
String _$authControllerHash() => r'e9596df7ed3dc977b0613a05c19280edb4b1242d';

/// See also [AuthController].
@ProviderFor(AuthController)
final authControllerProvider =
    AutoDisposeAsyncNotifierProvider<AuthController, void>.internal(
      AuthController.new,
      name: r'authControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authControllerHash,
      dependencies: <ProviderOrFamily>[authServiceProvider],
      allTransitiveDependencies: <ProviderOrFamily>{
        authServiceProvider,
        ...?authServiceProvider.allTransitiveDependencies,
      },
    );

typedef _$AuthController = AutoDisposeAsyncNotifier<void>;
String _$idTokenControllerHash() => r'97bed116866cd5cff96ea959c7b456d23fa28ae8';

/// See also [IdTokenController].
@ProviderFor(IdTokenController)
final idTokenControllerProvider =
    AutoDisposeAsyncNotifierProvider<IdTokenController, void>.internal(
      IdTokenController.new,
      name: r'idTokenControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$idTokenControllerHash,
      dependencies: <ProviderOrFamily>[authServiceProvider],
      allTransitiveDependencies: <ProviderOrFamily>{
        authServiceProvider,
        ...?authServiceProvider.allTransitiveDependencies,
      },
    );

typedef _$IdTokenController = AutoDisposeAsyncNotifier<void>;
String _$accessTokenControllerHash() =>
    r'b8fe5870001eca86fccb11d725c5bfca385a741f';

/// See also [AccessTokenController].
@ProviderFor(AccessTokenController)
final accessTokenControllerProvider =
    AutoDisposeAsyncNotifierProvider<AccessTokenController, void>.internal(
      AccessTokenController.new,
      name: r'accessTokenControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accessTokenControllerHash,
      dependencies: <ProviderOrFamily>[authServiceProvider],
      allTransitiveDependencies: <ProviderOrFamily>{
        authServiceProvider,
        ...?authServiceProvider.allTransitiveDependencies,
      },
    );

typedef _$AccessTokenController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
