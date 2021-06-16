import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/box/box_day_list.dart';

import 'box/box_tag.dart';
import 'box/box_task.dart';
import 'box/box_task_day_list_relation.dart';
import 'box/box_task_tag_relation.dart';
import 'type/task_type.dart';
import 'type/day_list_type.dart';
import 'type/tag_type.dart';
import 'type/task_day_list_rel_type.dart';
import 'type/task_tag_rel_type.dart';

final hiveW = HiveWrapper();

class HiveWrapper extends HostHiveWrapper {
  final boxs = {
    'tasks': BoxTasks(),
    'day_lists': BoxDayLists(),
    'tags': BoxTags(),
    'task_tag_rels': BoxTaskTagRels(),
    'task_day_list_rels': BoxTaskDayListRels(),
  };

  BoxTasks get tasks => boxs['tasks'] as BoxTasks;
  BoxDayLists get dayLists => boxs['day_lists'] as BoxDayLists;
  BoxTags get tags => boxs['tags'] as BoxTags;
  BoxTaskTagRels get taskTagRels => boxs['task_tag_rels'] as BoxTaskTagRels;
  BoxTaskDayListRels get taskDayListRels =>
      boxs['task_day_list_rels'] as BoxTaskDayListRels;

  final adaptors = [
    TaskAdapter(),
    DayListAdapter(),
    TagAdapter(),
    TaskTagRelAdapter(),
    TaskDayListRelAdapter(),
  ];

  Future<void> addTaskQuick(String title, {DateTime? date}) async {
    await addTask(title, '', date, []);
  }

  Future<void> addTask(
    String title,
    String description,
    DateTime? dateTime,
    List<Tag> tagList,
  ) async {
    final taskId = await tasks.create(title, description);

    if (dateTime != null) {
      await dayLists.submitTask(dateTime, taskId: taskId);
    }

    for (final tag in tagList) {
      if (tag.key == null) {
        await tags.setOnTask(tag.title, taskId: taskId);
        continue;
      }

      await tag.setOnTask(taskId);
    }
  }
}
