import 'package:hive/hive.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/day_list_type.dart';
import 'package:todoism/service/hive/type/task_day_list_rel_type.dart';

part 'task_type.g.dart';

@HiveType(typeId: 3)
class Task extends HiveObjectDub {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  bool? state;

  Iterable<TaskDayListRel> taskDayListRels() {
    return hasMany('task_day_list_rels', 'taskId');
  }

  Iterable<DayList> dayLists() {
    final uniqeList = <DayList>[];
    for (final rel in taskDayListRels()) {
      final a = rel.dayList();

      if (a != null) {
        if (uniqeList.where((element) => element.date == a.date).isEmpty) {
          uniqeList.add(a);
        }
      }
    }

    return uniqeList;
  }
}
