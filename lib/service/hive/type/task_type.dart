import 'package:hive/hive.dart';

part 'task_type.g.dart';

@HiveType(typeId: 3)
class Task extends HiveObject {
  /// tag parent
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  bool? state;
}
