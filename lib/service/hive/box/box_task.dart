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
  Iterable<Task> byFilter(List<int> tagsId) {
    if (tagsId.isEmpty) {
      return all;
    }

    return where(
      (task) {
        for (final rel in task.taskTagRels) {
          if (tagsId.contains(rel.tagId)) {
            return true;
          }
        }

        return false;
      },
    );
  }
}
