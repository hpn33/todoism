import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/type/tag_type.dart';

class BoxTags extends BoxWrapper<Tag> {
  BoxTags() : super('tags');

  @override
  Future<void> initBox(Box<Tag> box) async {}

  Future<int> getOrCreate(String title) {
    final list = where((element) => element.title == title);

    if (list.isNotEmpty) {
      return list.first.key;
    }

    return box.add(Tag()..title = title);
  }
}
