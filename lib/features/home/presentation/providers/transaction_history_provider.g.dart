// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionHistoryListHash() =>
    r'b76ab0da2d7536e5483edd1fda79f50f3b9ca675';

/// See also [transactionHistoryList].
@ProviderFor(transactionHistoryList)
final transactionHistoryListProvider =
    AutoDisposeStreamProvider<List<FinancialTransaction>>.internal(
  transactionHistoryList,
  name: r'transactionHistoryListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionHistoryListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionHistoryListRef
    = AutoDisposeStreamProviderRef<List<FinancialTransaction>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
