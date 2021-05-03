import 'package:hive/hive.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/day_list_type.dart';

import 'task_type.dart';

part 'task_day_list_rel_type.g.dart';

@HiveType(typeId: 5)
class TaskDayListRel extends HiveObjectDub {
  @HiveField(0)
  late int listId;

  @HiveField(1)
  late int taskId;

  getField(name) {
    {
      if (name == 'listId')
        return listId;
      else if (name == 'taskId') return taskId;
    }
  }

  DayList? dayList() {
    return hasOne('day_lists', listId);
  }

  Task? task() {
    return hasOne('tasks', taskId);
  }
}