import 'package:hive/hive.dart';

import '../hive_wrapper.dart';
import 'task_day_list_rel_type.dart';
import 'task_type.dart';

part 'day_list_type.g.dart';

@HiveType(typeId: 4)
class DayList extends HiveObjectWrapper {
  @HiveField(0)
  late DateTime date;

  Iterable<TaskDayListRel> taskDayListRels() {
    return hasMany('task_day_list_rels', targetField: 'listId');
  }

  Iterable<Task> tasks() {
    final list = <Task>[];

    for (final rel in taskDayListRels()) {
      final task = rel.task();

      if (task == null) {
        continue;
      }

      list.add(task);
    }

    return list;
  }
}
