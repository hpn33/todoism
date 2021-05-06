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
      hiveW.belongsTo(key, hiveW.taskDayListRels, 'listId');

  Iterable<Task> get tasks =>
      taskDayListRels.joinTo(hiveW.tasks, (e) => e.taskId);
}
