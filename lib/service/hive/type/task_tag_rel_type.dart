import 'package:hive/hive.dart';

part 'task_tag_rel_type.g.dart';

@HiveType(typeId: 2)
class TaskTagRel extends HiveObject {
  @HiveField(0)
  late int taskId;

  @HiveField(1)
  late int tagId;
}
