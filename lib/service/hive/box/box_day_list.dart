import 'package:hive/hive.dart';
import 'package:hive_wrapper/hive_wrapper.dart';
import 'package:todoism/service/hive/type/day_list_type.dart';

class BoxDayLists extends BoxWrapper<DayList> {
  BoxDayLists() : super('day_lists');

  @override
  Future<void> initBox(Box<DayList> box) async {}

  Future<int> getOrCreate(DateTime dateTime) async {
    // remove clock just keep date
    final fixedDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final list = box.values.where((element) => element.date == fixedDate);

    if (list.isNotEmpty) {
      return list.first.key;
    }

    return box.add(DayList()..date = fixedDate);
  }
}
