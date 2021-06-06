import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/day_list_type.dart';

import 'task_type.dart';

part 'task_day_list_rel_type.g.dart';

@HiveType(typeId: 5)
class TaskDayListRel extends HiveObjectWrapper {
  @HiveField(0)
  late int listId;

  @HiveField(1)
  late int taskId;

  DayList? get dayList => hasOne(hiveW.dayLists, ownerKey: listId);

  Task? get task => hasOne(hiveW.tasks, ownerKey: taskId);
}
