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
  @override
  Widget build(BuildContext context) {
    useListenable(hiveW.tasks.box.listenable());

    final tasks = useState(<Task>[]);

    final calendarFormat = useState(CalendarFormat.month);
    final focusedDay = useState(DateTime.now());
    final selectedDay = useState<DateTime?>(null);

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
                    // Use `selectedDayPredicate` to determine which day is currently selected.
                    // If this returns true, then `day` will be marked as selected.

                    // Using `isSameDay` is recommended to disregard
                    // the time-part of compared DateTime objects.
                    return isSameDay(selectedDay.value, day);
                  },
                  onDaySelected: (_selectedDay, _focusedDay) {
                    if (!isSameDay(selectedDay.value, _selectedDay)) {
                      selectedDay.value = _selectedDay;
                      focusedDay.value = _focusedDay;

                      final dayList = hiveW.dayLists.ofDay(_selectedDay);
                      if (dayList != null) {
                        tasks.value = dayList.tasks.toList().reversed.toList();
                      }
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
                AddTaskItem(dateTime: selectedDay.value),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.value.length,
                    itemBuilder: (context, index) {
                      final task = tasks.value[index];

                      return ProviderScope(
                        key: Key(task.title),
                        overrides: [
                          currentTask.overrideWithValue(task),
                        ],
                        child: TaskItem(key: Key(task.title)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
