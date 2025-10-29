// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fcmServiceHash() => r'158022e0bd2533b16759916ec1a56564888b5b46';

/// See also [fcmService].
@ProviderFor(fcmService)
final fcmServiceProvider = AutoDisposeProvider<FCMService>.internal(
  fcmService,
  name: r'fcmServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fcmServiceHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FcmServiceRef = AutoDisposeProviderRef<FCMService>;
String _$fcmTokenHash() => r'0216286f061205da5e3aeb2817fdd9a71d1c32d2';

/// See also [fcmToken].
@ProviderFor(fcmToken)
final fcmTokenProvider = AutoDisposeFutureProvider<String?>.internal(
  fcmToken,
  name: r'fcmTokenProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fcmTokenHash,
  dependencies: <ProviderOrFamily>[fcmServiceProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    fcmServiceProvider,
    ...?fcmServiceProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FcmTokenRef = AutoDisposeFutureProviderRef<String?>;
String _$tokenRefreshHash() => r'896a156d978547bcf2784fec00559c05cd2ca8a0';

/// See also [tokenRefresh].
@ProviderFor(tokenRefresh)
final tokenRefreshProvider = AutoDisposeStreamProvider<String>.internal(
  tokenRefresh,
  name: r'tokenRefreshProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tokenRefreshHash,
  dependencies: <ProviderOrFamily>[fcmServiceProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    fcmServiceProvider,
    ...?fcmServiceProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TokenRefreshRef = AutoDisposeStreamProviderRef<String>;
String _$foregroundMessagesHash() =>
    r'b56186839bd8f9c9deac910525eea99e1b2ebfa1';

/// See also [foregroundMessages].
@ProviderFor(foregroundMessages)
final foregroundMessagesProvider =
    AutoDisposeStreamProvider<RemoteMessage>.internal(
      foregroundMessages,
      name: r'foregroundMessagesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$foregroundMessagesHash,
      dependencies: <ProviderOrFamily>[fcmServiceProvider],
      allTransitiveDependencies: <ProviderOrFamily>{
        fcmServiceProvider,
        ...?fcmServiceProvider.allTransitiveDependencies,
      },
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ForegroundMessagesRef = AutoDisposeStreamProviderRef<RemoteMessage>;
String _$fcmControllerHash() => r'a15c9e64b346452b9f932c138221adf819df4910';

/// See also [FcmController].
@ProviderFor(FcmController)
final fcmControllerProvider =
    AutoDisposeAsyncNotifierProvider<FcmController, void>.internal(
      FcmController.new,
      name: r'fcmControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fcmControllerHash,
      dependencies: <ProviderOrFamily>[fcmServiceProvider],
      allTransitiveDependencies: <ProviderOrFamily>{
        fcmServiceProvider,
        ...?fcmServiceProvider.allTransitiveDependencies,
      },
    );

typedef _$FcmController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
