import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/type/tag_type.dart';

import '../hive_wrapper.dart';

class BoxTags extends BoxWrapper<Tag> {
  BoxTags() : super('tags');

  @override
  Future<void> initBox(Box<Tag> box) async {}

  Future<int> getOrCreate(String title) async {
    final list = where((element) => element.title == title);

    if (list.isNotEmpty) {
      return list.first.key;
    }

    return await box.add(Tag()..title = title);
  }

  Future<void> setOnTask(
    String tag, {
    required int taskId,
  }) async {
    final tagId = await getOrCreate(tag);

    hiveW.taskTagRels.submit(taskId, tagId);
  }
}
