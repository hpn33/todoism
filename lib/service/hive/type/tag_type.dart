import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
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

  Tag? get parentTag => hiveW.hasOne(hiveW.tags, parentId);

  Iterable<Tag> get subTags => hiveW.belongsTo(key, hiveW.tags, 'parentId');
}
