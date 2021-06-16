import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/type/task_day_list_rel_type.dart';

class BoxTaskDayListRels extends BoxWrapper<TaskDayListRel> {
  BoxTaskDayListRels() : super('task_day_list_rels', 1, {});

  @override
  Future<void> initBox(Box<TaskDayListRel> box) async {}

  Future<int> submit(int taskId, int dayListId) {
    return box.add(
      TaskDayListRel()
        ..taskId = taskId
        ..listId = dayListId,
    );
  }
}
