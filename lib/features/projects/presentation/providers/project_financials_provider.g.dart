// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_financials_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectFinancialsHash() => r'af24aaa615fc576117331cc406f3174c8cfa91fa';

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

/// See also [projectFinancials].
@ProviderFor(projectFinancials)
const projectFinancialsProvider = ProjectFinancialsFamily();

/// See also [projectFinancials].
class ProjectFinancialsFamily extends Family<AsyncValue<ProjectStats>> {
  /// See also [projectFinancials].
  const ProjectFinancialsFamily();

  /// See also [projectFinancials].
  ProjectFinancialsProvider call(
    String projectId,
  ) {
    return ProjectFinancialsProvider(
      projectId,
    );
  }

  @override
  ProjectFinancialsProvider getProviderOverride(
    covariant ProjectFinancialsProvider provider,
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
  String? get name => r'projectFinancialsProvider';
}

/// See also [projectFinancials].
class ProjectFinancialsProvider
    extends AutoDisposeStreamProvider<ProjectStats> {
  /// See also [projectFinancials].
  ProjectFinancialsProvider(
    String projectId,
  ) : this._internal(
          (ref) => projectFinancials(
            ref as ProjectFinancialsRef,
            projectId,
          ),
          from: projectFinancialsProvider,
          name: r'projectFinancialsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectFinancialsHash,
          dependencies: ProjectFinancialsFamily._dependencies,
          allTransitiveDependencies:
              ProjectFinancialsFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  ProjectFinancialsProvider._internal(
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
    Stream<ProjectStats> Function(ProjectFinancialsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectFinancialsProvider._internal(
        (ref) => create(ref as ProjectFinancialsRef),
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
  AutoDisposeStreamProviderElement<ProjectStats> createElement() {
    return _ProjectFinancialsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectFinancialsProvider && other.projectId == projectId;
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
mixin ProjectFinancialsRef on AutoDisposeStreamProviderRef<ProjectStats> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectFinancialsProviderElement
    extends AutoDisposeStreamProviderElement<ProjectStats>
    with ProjectFinancialsRef {
  _ProjectFinancialsProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectFinancialsProvider).projectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
