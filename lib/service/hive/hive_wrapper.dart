import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

class HiveWrapper {
  final tasks = BoxTasks();
  final dayList = BoxDayLists();
  final tags = BoxTags();
  final taskTagRels = BoxTaskTagRels();
  final taskDayListRels = BoxTaskDayListRels();

  Future<void> loadHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(DayListAdapter());
    Hive.registerAdapter(TagAdapter());
    Hive.registerAdapter(TaskTagRelAdapter());
    Hive.registerAdapter(TaskDayListRelAdapter());

    await tasks.load();
    await dayList.load();
    await tags.load();
    await taskTagRels.load();
    await taskDayListRels.load();

    // await tasks.clear();
    // await dayList.clear();
    // await tags.clear();
    // await taskTagRels.clear();
    // await taskDayListRels.clear();
  }

  Future<void> addTask(String title, String description) async {
    final taskId = await tasks.create(title, description);

    final dayListId = await dayList.getOrCreate(DateTime.now());

    taskDayListRels.submit(taskId, dayListId);
  }
}
