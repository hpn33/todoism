import 'package:hive/hive.dart';

import '../hive_wrapper.dart';
import 'tag_type.dart';
import 'task_type.dart';

part 'task_tag_rel_type.g.dart';

@HiveType(typeId: 2)
class TaskTagRel extends HiveObjectWrapper {
  @HiveField(0)
  late int taskId;

  @HiveField(1)
  late int tagId;

  getField(name) {
    if (name == 'taskId') {
      return taskId;
    }
    if (name == 'tagId') {
      return tagId;
    }
  }

  Task? task() {
    return hasOne('tasks', localKey: taskId);
  }

  Tag? tag() {
    return hasOne('tags', localKey: tagId);
  }
}
