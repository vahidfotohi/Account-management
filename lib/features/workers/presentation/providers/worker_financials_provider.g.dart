// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_financials_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workerFinancialsHash() => r'023a3b6ae129f6d112368254910fc85601f1fce7';

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

/// See also [workerFinancials].
@ProviderFor(workerFinancials)
const workerFinancialsProvider = WorkerFinancialsFamily();

/// See also [workerFinancials].
class WorkerFinancialsFamily extends Family<AsyncValue<WorkerStats>> {
  /// See also [workerFinancials].
  const WorkerFinancialsFamily();

  /// See also [workerFinancials].
  WorkerFinancialsProvider call(
    String workerId,
  ) {
    return WorkerFinancialsProvider(
      workerId,
    );
  }

  @override
  WorkerFinancialsProvider getProviderOverride(
    covariant WorkerFinancialsProvider provider,
  ) {
    return call(
      provider.workerId,
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
  String? get name => r'workerFinancialsProvider';
}

/// See also [workerFinancials].
class WorkerFinancialsProvider extends AutoDisposeFutureProvider<WorkerStats> {
  /// See also [workerFinancials].
  WorkerFinancialsProvider(
    String workerId,
  ) : this._internal(
          (ref) => workerFinancials(
            ref as WorkerFinancialsRef,
            workerId,
          ),
          from: workerFinancialsProvider,
          name: r'workerFinancialsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workerFinancialsHash,
          dependencies: WorkerFinancialsFamily._dependencies,
          allTransitiveDependencies:
              WorkerFinancialsFamily._allTransitiveDependencies,
          workerId: workerId,
        );

  WorkerFinancialsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workerId,
  }) : super.internal();

  final String workerId;

  @override
  Override overrideWith(
    FutureOr<WorkerStats> Function(WorkerFinancialsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkerFinancialsProvider._internal(
        (ref) => create(ref as WorkerFinancialsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workerId: workerId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WorkerStats> createElement() {
    return _WorkerFinancialsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkerFinancialsProvider && other.workerId == workerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkerFinancialsRef on AutoDisposeFutureProviderRef<WorkerStats> {
  /// The parameter `workerId` of this provider.
  String get workerId;
}

class _WorkerFinancialsProviderElement
    extends AutoDisposeFutureProviderElement<WorkerStats>
    with WorkerFinancialsRef {
  _WorkerFinancialsProviderElement(super.provider);

  @override
  String get workerId => (origin as WorkerFinancialsProvider).workerId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
