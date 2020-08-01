part of '../app_database.dart';

@UseDao(
  tables: [Tasks, Tags],
//    queries: {
//  'completedTasksGenerated': 'SELECT * FROM tasks WHERE completed = 1 ORDER BY due_date DESC, name;'
//}
)
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin, _$TagDaoMixin {
  final AppDatabase db;

  TaskDao(this.db) : super(db);

  Future<List<Task>> getAllTask() => select(tasks).get();

//  Stream<List<Task>> watchAllTasks() => select(tasks).watch();
  // without tag
  Stream<List<Task>> watchAllTask() {
    return (select(tasks)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.desc),
              (t) => OrderingTerm(expression: t.name)
            ]),
          ))
        .watch();
  }

  // with tag
  Stream<List<TaskWithTag>> watchAllTaskWithTag() {
    return (select(tasks)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.desc),
              (t) => OrderingTerm(expression: t.name)
            ]),
          ))
        .join(
          [
            // Join all the tasks with their tags.
            // It's important that we use equalsExp and not just equals.
            // This way, we can join using all tag names in the tasks table, not just a specific one.
            leftOuterJoin(tags, tags.name.equalsExp(tasks.tagName)),
          ],
        )
        .watch()
        .map((rows) => rows
            .map((row) => TaskWithTag(task: row.readTable(tasks), tag: row.readTable(tags)))
            .toList());
  }

  Stream<List<Task>> watchCompletedTask() {
    return (select(tasks)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.desc),
              (t) => OrderingTerm(expression: t.name)
            ]),
          )
          ..where(
            (t) => t.completed.equals(true),
          ))
        .watch();
  }

  // with tag
  Stream<List<TaskWithTag>> watchCompletedTaskWithTag() {
    return (select(tasks)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.desc),
              (t) => OrderingTerm(expression: t.name)
            ]),
          )
          ..where(
            (t) => t.completed.equals(true),
          ))
        .join(
          [
            // Join all the tasks with their tags.
            // It's important that we use equalsExp and not just equals.
            // This way, we can join using all tag names in the tasks table, not just a specific one.
            leftOuterJoin(tags, tags.name.equalsExp(tasks.tagName)),
          ],
        )
        .watch()
        .map((rows) => rows
            .map((row) => TaskWithTag(task: row.readTable(tasks), tag: row.readTable(tags)))
            .toList());
  }

  // Custom Method
//  Stream<List<Task>> watchCompletedTasksCustom() {
//    return customSelect(
//      'SELECT * FROM tasks WHERE completed = 1 ORDER BY due_date DESC, name;',
//      // The Stream will emit new values when the data inside the Tasks table changes
//      readsFrom: {tasks},
//    )
//    // customSelect or customSelectStream gives us QueryRow list
//    // This runs each time the Stream emits a new value.
//        .map((rows) {
//      // Turning the data of a row into a Task object
//      return rows.map((row) => Task.fromData(row.data, db)).toList();
//    });
//  }

//  Future insertTask(Task task) => into(tasks).insert(task);
  Future insertTask(Insertable<Task> task) => into(tasks).insert(task);

//  Future updateTask(Task task) => update(tasks).replace(task);
  Future updateTask(Insertable<Task> task) => update(tasks).replace(task);

//  Future deleteTask(Task task) => delete(tasks).delete(task);
  Future deleteTask(Insertable<Task> task) => delete(tasks).delete(task);
}
