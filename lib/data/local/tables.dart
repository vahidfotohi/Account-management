// lib/data/local/tables.dart
import 'package:drift/drift.dart';

// جداول برای Workers
class Workers extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text().withLength(min: 1, max: 100)();

  TextColumn get jobTitle => text().nullable()();

  // 0: Daily, 1: Hourly, 2: Metri
  IntColumn get wageType => integer()();

  RealColumn get baseWage => real()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  TextColumn get phoneNumber => text().nullable()();

  TextColumn get notes => text().nullable()();

  TextColumn get cardNumber => text().nullable()(); // شماره کارت
  TextColumn get shebaNumber => text().nullable()(); // شماره شبا
  RealColumn get initialDebt => real().withDefault(const Constant(0))();

  // Sync fields
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// جداول برای Projects
class Projects extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get location => text().nullable()();

  TextColumn get employerName => text().nullable()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// جداول برای WorkEntries (کارکرد)
class WorkEntries extends Table {
  TextColumn get id => text()();

  TextColumn get workerId => text().references(Workers, #id)();

  TextColumn get projectId => text().references(Projects, #id)();

  DateTimeColumn get date => dateTime()();

  RealColumn get amount => real()(); // ساعت یا متر یا روز
  TextColumn get description => text().nullable()();

  RealColumn get wageAtTime => real().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// جداول برای Payments (پرداختی به کارگر)
class Payments extends Table {
  TextColumn get id => text()();

  TextColumn get workerId => text().references(Workers, #id)();

  RealColumn get amount => real()();

  DateTimeColumn get date => dateTime()();

  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Receipts extends Table {
  TextColumn get id => text()();

  TextColumn get projectId => text().references(Projects, #id)();

  RealColumn get amount => real()();

  DateTimeColumn get date => dateTime()();

  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
