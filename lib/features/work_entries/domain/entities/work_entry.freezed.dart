// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkEntry {
  String get id => throw _privateConstructorUsedError;
  String get workerId => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get wageAtTime => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of WorkEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkEntryCopyWith<WorkEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkEntryCopyWith<$Res> {
  factory $WorkEntryCopyWith(WorkEntry value, $Res Function(WorkEntry) then) =
      _$WorkEntryCopyWithImpl<$Res, WorkEntry>;
  @useResult
  $Res call(
      {String id,
      String workerId,
      String projectId,
      DateTime date,
      double amount,
      String? description,
      double wageAtTime,
      DateTime createdAt});
}

/// @nodoc
class _$WorkEntryCopyWithImpl<$Res, $Val extends WorkEntry>
    implements $WorkEntryCopyWith<$Res> {
  _$WorkEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workerId = null,
    Object? projectId = null,
    Object? date = null,
    Object? amount = null,
    Object? description = freezed,
    Object? wageAtTime = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workerId: null == workerId
          ? _value.workerId
          : workerId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      wageAtTime: null == wageAtTime
          ? _value.wageAtTime
          : wageAtTime // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkEntryImplCopyWith<$Res>
    implements $WorkEntryCopyWith<$Res> {
  factory _$$WorkEntryImplCopyWith(
          _$WorkEntryImpl value, $Res Function(_$WorkEntryImpl) then) =
      __$$WorkEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String workerId,
      String projectId,
      DateTime date,
      double amount,
      String? description,
      double wageAtTime,
      DateTime createdAt});
}

/// @nodoc
class __$$WorkEntryImplCopyWithImpl<$Res>
    extends _$WorkEntryCopyWithImpl<$Res, _$WorkEntryImpl>
    implements _$$WorkEntryImplCopyWith<$Res> {
  __$$WorkEntryImplCopyWithImpl(
      _$WorkEntryImpl _value, $Res Function(_$WorkEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workerId = null,
    Object? projectId = null,
    Object? date = null,
    Object? amount = null,
    Object? description = freezed,
    Object? wageAtTime = null,
    Object? createdAt = null,
  }) {
    return _then(_$WorkEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workerId: null == workerId
          ? _value.workerId
          : workerId // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      wageAtTime: null == wageAtTime
          ? _value.wageAtTime
          : wageAtTime // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$WorkEntryImpl implements _WorkEntry {
  const _$WorkEntryImpl(
      {required this.id,
      required this.workerId,
      required this.projectId,
      required this.date,
      required this.amount,
      this.description,
      required this.wageAtTime,
      required this.createdAt});

  @override
  final String id;
  @override
  final String workerId;
  @override
  final String projectId;
  @override
  final DateTime date;
  @override
  final double amount;
  @override
  final String? description;
  @override
  final double wageAtTime;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'WorkEntry(id: $id, workerId: $workerId, projectId: $projectId, date: $date, amount: $amount, description: $description, wageAtTime: $wageAtTime, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workerId, workerId) ||
                other.workerId == workerId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.wageAtTime, wageAtTime) ||
                other.wageAtTime == wageAtTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, workerId, projectId, date,
      amount, description, wageAtTime, createdAt);

  /// Create a copy of WorkEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkEntryImplCopyWith<_$WorkEntryImpl> get copyWith =>
      __$$WorkEntryImplCopyWithImpl<_$WorkEntryImpl>(this, _$identity);
}

abstract class _WorkEntry implements WorkEntry {
  const factory _WorkEntry(
      {required final String id,
      required final String workerId,
      required final String projectId,
      required final DateTime date,
      required final double amount,
      final String? description,
      required final double wageAtTime,
      required final DateTime createdAt}) = _$WorkEntryImpl;

  @override
  String get id;
  @override
  String get workerId;
  @override
  String get projectId;
  @override
  DateTime get date;
  @override
  double get amount;
  @override
  String? get description;
  @override
  double get wageAtTime;
  @override
  DateTime get createdAt;

  /// Create a copy of WorkEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkEntryImplCopyWith<_$WorkEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
