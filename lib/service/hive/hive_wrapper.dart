import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoism/service/hive/box/box_task.dart';
import 'package:todoism/service/hive/box/box_task_tag_relation.dart';
import 'package:todoism/service/hive/type/tag_type.dart';
import 'package:todoism/service/hive/type/task_type.dart';

import 'box/box_tag.dart';
import 'type/task_tag_rel_type.dart';

final hiveW = HiveWrapper();

class HiveWrapper {
  final tasks = BoxTasks();
  final tags = BoxTags();
  final taskTagRels = BoxTaskTagRels();

  Future<void> loadHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TagAdapter());
    Hive.registerAdapter(TaskTagRelAdapter());

    await tasks.load();
    await tags.load();
    await taskTagRels.load();
  }
}
