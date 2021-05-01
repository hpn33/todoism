import 'package:hive/hive.dart';

part 'task_day_list_rel_type.g.dart';

@HiveType(typeId: 5)
class TaskDayListRel extends HiveObject {
  @HiveField(0)
  late int listId;

  @HiveField(1)
  late int taskId;
}
