import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/type/day_list_type.dart';

class BoxDayLists extends BoxWrapper<DayList> {
  BoxDayLists() : super('day_lists');

  @override
  Future<void> initBox(Box<DayList> box) async {}

  DayList ofDay(DateTime dateTime) {
    final fixedDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final dayLists = where((element) => element.date == fixedDate);

    if (dayLists.isNotEmpty) {
      return dayLists.first;
    }

    final id = box.add(DayList()..date = fixedDate);

    return where((element) => element.key == id).first;
  }

  // Iterable<DayList> sorted() {
  //   return (all.toList()..sort((a, b) => b.date.compareTo(a.date)));
  // }

  Future<void> submitTask(
    DateTime dateTime, {
    required int taskId,
  }) async {
    ofDay(dateTime).submitTask(taskId);
  }
}
