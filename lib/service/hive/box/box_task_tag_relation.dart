import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/type/task_tag_rel_type.dart';

class BoxTaskTagRels extends BoxWrapper<TaskTagRel> {
  BoxTaskTagRels() : super('task_tag_rels');

  @override
  Future<void> initBox(Box<TaskTagRel> box) async {}

  Future<int> submit(int taskId, int tagId) {
    return box.add(
      TaskTagRel()
        ..taskId = taskId
        ..tagId = tagId,
    );
  }
}
