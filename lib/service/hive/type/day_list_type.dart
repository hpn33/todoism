import 'package:hive/hive.dart';

import '../hive_wrapper.dart';
import 'task_day_list_rel_type.dart';
import 'task_type.dart';

part 'day_list_type.g.dart';

@HiveType(typeId: 4)
class DayList extends HiveObjectDub {
  @HiveField(0)
  late DateTime date;

  Iterable<TaskDayListRel> taskDayListRels() {
    return hasMany('task_day_list_rels', 'listId');
  }

  Iterable<Task> tasks() {
    final s = <Task>[];
    for (final rel in taskDayListRels()) {
      final task = rel.task();

      if (task != null) {
        s.add(task);
      }
    }

    return s;
  }
}
