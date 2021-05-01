import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/type/tag_type.dart';

class BoxTags extends BoxWrapper<Tag> {
  BoxTags() : super('tags');

  @override
  Future<void> initBox(Box<Tag> box) async {}
}
