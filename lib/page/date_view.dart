import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoism/service/hive/type/task_type.dart';

import 'component/add_task_item.dart';
import 'component/task_item.dart';

class DateView extends HookWidget {
  static final selectedDayP = StateProvider((ref) => DateTime.now());
  final tasksProvider = FutureProvider<List<Task>>((ref) async {
    final selectedDay = ref.watch(selectedDayP);

    final dayList = hiveW.dayLists.ofDay(selectedDay.state);
    return dayList != null ? dayList.tasks.toList().reversed.toList() : [];
  });

  @override
  Widget build(BuildContext context) {
    useListenable(hiveW.tasks.box.listenable());

    final calendarFormat = useState(CalendarFormat.month);
    final focusedDay = useState(DateTime.now());
    final selectedDay = useProvider(selectedDayP);

    final tasks = useProvider(tasksProvider);

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Card(
                child: TableCalendar<Task>(
                  firstDay: DateTime.now().add(Duration(days: -1 * 365 * 10)),
                  lastDay: DateTime.now().add(Duration(days: 365 * 10)),
                  focusedDay: focusedDay.value,
                  calendarFormat: calendarFormat.value,
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDay.state, day);
                  },
                  onDaySelected: (_selectedDay, _focusedDay) {
                    if (!isSameDay(selectedDay.state, _selectedDay)) {
                      selectedDay.state = _selectedDay;
                      focusedDay.value = _focusedDay;
                    }
                  },
                  onFormatChanged: (format) {
                    if (calendarFormat.value != format) {
                      calendarFormat.value = format;
                    }
                  },
                  onPageChanged: (_focusedDay) {
                    focusedDay.value = _focusedDay;
                  },
                  eventLoader: (datetime) {
                    final daylist = hiveW.dayLists.ofDay(datetime);

                    if (daylist == null) {
                      return [];
                    }

                    return daylist.tasks.toList();
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AddTaskItem(dateTime: selectedDay.state),
                Expanded(
                  child: tasks.when(data: (_tasks) {
                    return ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];

                        return ProviderScope(
                          key: Key(task.title),
                          overrides: [
                            currentTask.overrideWithValue(task),
                          ],
                          child: TaskItem(key: Key(task.title)),
                        );
                      },
                    );
                  }, loading: () {
                    return Center(child: CircularProgressIndicator());
                  }, error: (o, s) {
                    return Center(child: Text('$o\n$s'));
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
