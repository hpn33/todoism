import 'package:hive/hive.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';

part 'tag_type.g.dart';

@HiveType(typeId: 0)
class Tag extends HiveObjectWrapper {
  /// tag parent
  @HiveField(0)
  int? parentId;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String description;

  getField(String name) {
    if (name == 'parentId') {
      return parentId;
    }
  }

  Tag? parentTag() {
    if (parentId == null) {
      return null;
    }

    return hasOne('tags', localKey: parentId);
  }

  Iterable<Tag> subTags() {
    return hasMany('tags', targetField: 'parentId');
  }
}
