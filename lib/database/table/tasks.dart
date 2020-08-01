part of '../app_database.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Add tagName as foreign key from table tags
  TextColumn get tagName => text().nullable().customConstraint('NULL REFERENCES tags(name)')();

  TextColumn get name => text().withLength(min: 1, max: 50)();

  DateTimeColumn get dueDate => dateTime().nullable()();

  BoolColumn get completed => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id, name};
}
