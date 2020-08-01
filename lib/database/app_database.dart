import 'package:moor_flutter/moor_flutter.dart';

part 'app_database.g.dart';

part 'dao/tags.dao.dart';

part 'dao/tasks.dao.dart';

part 'table/tags.dart';

part 'table/tasks.dart';

//AppDatabase _instance;
//AppDatabase get database {
//  return _instance ??= AppDatabase._();
//}

@UseMoor(tables: [Tasks, Tags], daos: [TaskDao, TagDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite', logStatements: true));

  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from == 1) {
            await migrator.addColumn(tasks, tasks.tagName);
            await migrator.createTable(tags);
          }
        },
//        beforeOpen: (db) async {
//          await customStatement('PRAGMA foreign_keys = ON');
//        },
      );

  /// Go To DAO
//  Future<List<Task>> getAllTask() => select(tasks).get();
//
//  Stream<List<Task>> watchAllTasks() => select(tasks).watch();
//
//  Future insertTask(Task task) => into(tasks).insert(task);
//
//  Future updateTask(Task task) => update(tasks).replace(task);
//
//  Future deleteTask(Task task) => delete(tasks).delete(task);

}

// class join task with tag
class TaskWithTag {
  final Task task;
  final Tag tag;

  TaskWithTag({
    @required this.task,
    @required this.tag,
  });
}
