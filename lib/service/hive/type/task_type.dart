import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/day_list_type.dart';
import 'package:todoism/service/hive/type/task_day_list_rel_type.dart';

import 'tag_type.dart';
import 'task_tag_rel_type.dart';

part 'task_type.g.dart';

@HiveType(typeId: 3)
class Task extends HiveObjectWrapper {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  bool? state;

  Task();

  factory Task.empty() {
    return Task()
      ..title = ''
      ..description = ''
      ..state = false;
  }

  Iterable<TaskDayListRel> get taskDayListRels =>
      belongsTo(hiveW.taskDayListRels, getForeignKey: (e) => e.taskId);

  Iterable<TaskTagRel> get taskTagRels =>
      belongsTo(hiveW.taskTagRels, getForeignKey: (e) => e.taskId);

  Iterable<DayList> get dayLists =>
      taskDayListRels.joinTo(hiveW.dayLists, (e) => e.listId, uniqe: true);

  Iterable<Tag> get tags => taskTagRels.joinTo(hiveW.tags, (e) => e.tagId);

  Future<void> addTag(Tag tag) async {
    if (tag.key == null) {
      hiveW.tags.setOnTask(tag.title, taskId: key);
      return;
    }

    hiveW.taskTagRels.submit(key, tag.key);
  }
}
