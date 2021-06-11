import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/type/task_type.dart';

class BoxTasks extends BoxWrapper<Task> {
  BoxTasks() : super('tasks');

  @override
  Future<void> initBox(Box<Task> box) async {}

  Future<int> create(String title, String description) {
    return box.add(
      Task()
        ..title = title
        ..description = description
        ..state = false,
    );
  }

  // return any task that have at last one tag filter
  // if was inner should mach with all tags
  // Iterable<Task> byTags(List<int> tagIds, {bool inner = false}) {
  //   final tasks = all.toList().reversed;

  //   if (tagIds.isEmpty) {
  //     return tasks;
  //   }

  //   return tasks.where(
  //     (task) {
  //       final matchIds = task.taskTagRels
  //           .map((e) => e.tagId)
  //           .where((id) => tagIds.contains(id));

  //       if (!inner) {
  //         return matchIds.isNotEmpty;
  //       }

  //       var vals = tagIds.map((id) => matchIds.contains(id));

  //       for (final val in vals) {
  //         if (!val) {
  //           return false;
  //         }
  //       }

  //       return true;
  //     },
  //   );
  // }
}
