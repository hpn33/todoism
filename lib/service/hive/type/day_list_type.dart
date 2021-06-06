import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';

import '../hive_wrapper.dart';
import 'task_day_list_rel_type.dart';
import 'task_type.dart';

part 'day_list_type.g.dart';

@HiveType(typeId: 4)
class DayList extends HiveObjectWrapper {
  @HiveField(0)
  late DateTime date;

  Iterable<TaskDayListRel> get taskDayListRels =>
      belongsTo(hiveW.taskDayListRels, getForeignKey: (e) => e.listId);

  Iterable<Task> get tasks =>
      taskDayListRels.joinTo(hiveW.tasks, (e) => e.taskId);

  Future<void> submitTask(int taskId) async {
    hiveW.taskDayListRels.submit(taskId, key);
  }
}
