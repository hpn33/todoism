import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/box/box_day_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  @override
  final boxs = [
    BoxTasks(),
    BoxDayLists(),
    BoxTags(),
    BoxTaskTagRels(),
    BoxTaskDayListRels(),
  ];

  BoxTasks get tasks => boxs[0] as BoxTasks;
  BoxDayLists get dayLists => boxs[1] as BoxDayLists;
  BoxTags get tags => boxs[2] as BoxTags;
  BoxTaskTagRels get taskTagRels => boxs[3] as BoxTaskTagRels;
  BoxTaskDayListRels get taskDayListRels => boxs[4] as BoxTaskDayListRels;

  @override
  Future<void> loadHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(DayListAdapter());
    Hive.registerAdapter(TagAdapter());
    Hive.registerAdapter(TaskTagRelAdapter());
    Hive.registerAdapter(TaskDayListRelAdapter());

    for (final box in boxs) {
      await box.load();
    }
  }

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
