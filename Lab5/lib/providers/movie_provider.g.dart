// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiServiceHash() => r'32d6851ca3e737384abdcd4220efc9cc1dbd7812';

/// See also [apiService].
@ProviderFor(apiService)
final apiServiceProvider = AutoDisposeProvider<ApiService>.internal(
  apiService,
  name: r'apiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiServiceRef = AutoDisposeProviderRef<ApiService>;
String _$movieRepositoryHash() => r'776b895c1a60816cb2f388b9f9dae8a5af572a1c';

/// See also [movieRepository].
@ProviderFor(movieRepository)
final movieRepositoryProvider = AutoDisposeProvider<MovieRepository>.internal(
  movieRepository,
  name: r'movieRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$movieRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MovieRepositoryRef = AutoDisposeProviderRef<MovieRepository>;
String _$movieListHash() => r'66f0afa878585dc12f9fdcdd1b046dd6695eaee4';

/// See also [MovieList].
@ProviderFor(MovieList)
final movieListProvider =
    AutoDisposeAsyncNotifierProvider<MovieList, List<Movie>>.internal(
      MovieList.new,
      name: r'movieListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$movieListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MovieList = AutoDisposeAsyncNotifier<List<Movie>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
