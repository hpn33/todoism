import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/type/day_list_type.dart';
import 'package:todoism/util/date_extention.dart';

class BoxDayLists extends BoxWrapper<DayList> {
  BoxDayLists() : super('day_lists');

  @override
  Future<void> initBox(Box<DayList> box) async {}

  DayList ofDay(DateTime dateTime) {
    final fixedDate = dateTime.justDate();

    final dayLists = where((element) => element.date == fixedDate);

    if (dayLists.isNotEmpty) {
      return dayLists.first;
    }

    final id = box.add(DayList()..date = fixedDate);

    return where((element) => element.key == id).first;
  }

  Future<void> submitTask(
    DateTime dateTime, {
    required int taskId,
  }) async {
    ofDay(dateTime).submitTask(taskId);
  }

  List<DayList> after(DateTime dateTime) {
    return where((element) => element.date.isAfter(dateTime)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<DayList> before(DateTime date) {
    return where((element) => element.date.isBefore(date)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}
