import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/type/task_day_list_rel_type.dart';

class BoxTaskDayListRels extends BoxWrapper<TaskDayListRel> {
  BoxTaskDayListRels() : super('task_day_list_rels');

  @override
  Future<void> initBox(Box<TaskDayListRel> box) async {}

  void submit(int taskId, int dayListId) {
    box.add(
      TaskDayListRel()
        ..taskId = taskId
        ..listId = dayListId,
    );
  }
}
