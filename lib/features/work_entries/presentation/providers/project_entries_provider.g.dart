// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_entries_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectEntriesHash() => r'08d0c32653472dbd2fc16fe17d72c66dc290107a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [projectEntries].
@ProviderFor(projectEntries)
const projectEntriesProvider = ProjectEntriesFamily();

/// See also [projectEntries].
class ProjectEntriesFamily extends Family<AsyncValue<List<WorkEntry>>> {
  /// See also [projectEntries].
  const ProjectEntriesFamily();

  /// See also [projectEntries].
  ProjectEntriesProvider call(
    String projectId,
  ) {
    return ProjectEntriesProvider(
      projectId,
    );
  }

  @override
  ProjectEntriesProvider getProviderOverride(
    covariant ProjectEntriesProvider provider,
  ) {
    return call(
      provider.projectId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'projectEntriesProvider';
}

/// See also [projectEntries].
class ProjectEntriesProvider
    extends AutoDisposeStreamProvider<List<WorkEntry>> {
  /// See also [projectEntries].
  ProjectEntriesProvider(
    String projectId,
  ) : this._internal(
          (ref) => projectEntries(
            ref as ProjectEntriesRef,
            projectId,
          ),
          from: projectEntriesProvider,
          name: r'projectEntriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectEntriesHash,
          dependencies: ProjectEntriesFamily._dependencies,
          allTransitiveDependencies:
              ProjectEntriesFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  ProjectEntriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  Override overrideWith(
    Stream<List<WorkEntry>> Function(ProjectEntriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectEntriesProvider._internal(
        (ref) => create(ref as ProjectEntriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<WorkEntry>> createElement() {
    return _ProjectEntriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectEntriesProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProjectEntriesRef on AutoDisposeStreamProviderRef<List<WorkEntry>> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectEntriesProviderElement
    extends AutoDisposeStreamProviderElement<List<WorkEntry>>
    with ProjectEntriesRef {
  _ProjectEntriesProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectEntriesProvider).projectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
