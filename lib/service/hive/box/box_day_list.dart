import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/type/day_list_type.dart';

import '../hive_wrapper.dart';

class BoxDayLists extends BoxWrapper<DayList> {
  BoxDayLists() : super('day_lists');

  @override
  Future<void> initBox(Box<DayList> box) async {}

  Iterable<DayList> onDate(DateTime dateTime) {
    // remove clock just keep date
    final fixedDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    return where((element) => element.date == fixedDate);
  }

  Future<int> getOrCreate(DateTime dateTime) async {
    final fixedDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final list = onDate(dateTime);

    if (list.isNotEmpty) {
      return list.first.key;
    }

    return box.add(DayList()..date = fixedDate);
  }

  DayList? ofDay(DateTime dateTime) {
    final dayLists = onDate(dateTime);

    if (dayLists.isEmpty) {
      return null;
    }

    return dayLists.first;
  }

  Iterable<DayList> sorted() {
    return (all.toList()..sort((a, b) => b.date.compareTo(a.date)));
  }

  Future<void> setOnTask(
    DateTime dateTime, {
    required int taskId,
  }) async {
    final dayListId = await getOrCreate(dateTime);

    hiveW.taskDayListRels.submit(taskId, dayListId);
  }
}
