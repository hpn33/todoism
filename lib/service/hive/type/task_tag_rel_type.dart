import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';

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

  Task? get task => hasOne(hiveW.tasks);

  Tag? get tag => hasOne(hiveW.tags);
}
