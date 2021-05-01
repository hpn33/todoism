import 'package:hive/hive.dart';

part 'tag_type.g.dart';

@HiveType(typeId: 0)
class Tag extends HiveObject {
  /// tag parent
  @HiveField(0)
  int? parentId;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String description;
}
