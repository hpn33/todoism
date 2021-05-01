import 'package:hive/hive.dart';

part 'day_list_type.g.dart';

@HiveType(typeId: 4)
class DayList extends HiveObject {
  @HiveField(0)
  late DateTime date;
}
