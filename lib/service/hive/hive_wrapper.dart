import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  final boxs = <String, BoxWrapper>{
    'tasks': BoxTasks(),
    'day_lists': BoxDayLists(),
    'tags': BoxTags(),
    'task_tag_rels': BoxTaskTagRels(),
    'task_day_list_rels': BoxTaskDayListRels(),
  };

  BoxWrapper<BoxType> getBox<BoxType>(String boxName) {
    return boxs[boxName] as BoxWrapper<BoxType>;
  }

  BoxTasks get tasks => boxs['tasks'] as BoxTasks;
  BoxDayLists get dayLists => boxs['day_lists'] as BoxDayLists;
  BoxTags get tags => boxs['tags'] as BoxTags;
  BoxTaskTagRels get taskTagRels => boxs['task_tag_rels'] as BoxTaskTagRels;
  BoxTaskDayListRels get taskDayListRels =>
      boxs['task_day_list_rels'] as BoxTaskDayListRels;

  Future<void> loadHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(DayListAdapter());
    Hive.registerAdapter(TagAdapter());
    Hive.registerAdapter(TaskTagRelAdapter());
    Hive.registerAdapter(TaskDayListRelAdapter());

    boxs.forEach((key, value) async => await value.load());
  }

  Future<void> addTask(String title, String description) async {
    final taskId = await tasks.create(title, description);

    final dayListId = await dayLists.getOrCreate(DateTime.now());

    taskDayListRels.submit(taskId, dayListId);
  }
}

abstract class HostHiveWrapper {
  late Map<String, BoxWrapper> boxs;

  BoxWrapper<BoxType> getBox<BoxType>(String boxName);
}

class HiveObjectWrapper extends HiveObject {
  getField(String name) {}

  Iterable<ReturnType> hasMany<ReturnType extends HiveObjectWrapper>(
    String boxName, {
    String? targetField,
    int? localKey,
  }) {
    localKey = localKey ?? key;

    final box = hiveW.getBox<ReturnType>(boxName);

    return box.where((element) {
      final field =
          targetField == null ? element.key : element.getField(targetField);

      return field == localKey;
    });
  }

  ReturnType? hasOne<ReturnType extends HiveObjectWrapper>(
    String boxName, {
    String? targetField,
    int? localKey,
  }) {
    localKey = (localKey ?? key);

    final box = hiveW.getBox<ReturnType>(boxName);

    final selected = box.where((element) {
      final field =
          targetField == null ? element.key : element.getField(targetField);

      return field == localKey;
    });

    if (selected.isEmpty) {
      return null;
    }

    return selected.first;
  }

  // ReturnType belongsTo<ReturnType extends HiveObjectDub>(
  //   String boxName,
  // ) {
  //   return hiveW
  //       .getBox<ReturnType>(boxName)
  //       .where((element) => element.key == key)
  //       .first;
  // }
}
