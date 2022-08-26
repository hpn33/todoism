import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/task_tag_rel_type.dart';

import 'task_type.dart';

part 'tag_type.g.dart';

@HiveType(typeId: 0)
class Tag extends HiveObjectWrapper {
  /// tag parent
  @HiveField(0)
  int? parentId;

  @HiveField(1)
  late String title;

  @HiveField(2)
  String? description;

  @override
  Future<void> delete() {
    for (var rel in taskTagRels) {
      rel.delete();
    }

    return super.delete();
  }

  Tag? get parentTag => hasOne(hiveW.tags, ownerKey: parentId);

  Iterable<Tag> get subTags =>
      belongsTo(hiveW.tags, getForeignKey: (e) => e.parentId);

  Iterable<TaskTagRel> get taskTagRels =>
      belongsTo(hiveW.taskTagRels, getForeignKey: (e) => e.tagId);

  Iterable<Task> get tasks => taskTagRels.joinTo(hiveW.tasks, (e) => e.taskId);

  Future<void> setOnTask(int taskId) async {
    hiveW.taskTagRels.submit(taskId, key);
  }
}
