import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todoism/page/home/component/add_task_item.dart';
import 'package:todoism/page/home/component/dialog_task_panel.dart';
import 'package:todoism/page/home/component/task_item.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoism/service/hive/type/day_list_type.dart';
import 'package:todoism/service/hive/type/task_type.dart';
import 'package:todoism/widget/provide_future_list.dart';

class DateView extends HookConsumerWidget {
  final selectedDayP = StateProvider((ref) => DateTime.now());
  late final StateProvider<DayList> dayListP = StateProvider<DayList>((ref) {
    final date = ref.watch(selectedDayP.state).state;

    return hiveW.dayLists.ofDay(date);
  });

  late final FutureProvider<List<Task>> tasksProvider =
      FutureProvider<List<Task>>((ref) async {
    final dayList = ref.watch(dayListP.state).state;

    return dayList.tasks.toList().reversed.toList();
  });

  @override
  Widget build(BuildContext context, ref) {
    useListenable(hiveW.tasks.box.listenable()).addListener(() {
      ref.refresh(tasksProvider);
    });

    final calendarFormat = useState(CalendarFormat.month);
    final focusedDay = useState(DateTime.now());
    final selectedDay = ref.watch(selectedDayP.state);

    final tasks = ref.watch(tasksProvider);

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Card(
                child: TableCalendar<Task>(
                  firstDay:
                      DateTime.now().add(const Duration(days: -1 * 365 * 10)),
                  lastDay: DateTime.now().add(const Duration(days: 365 * 10)),
                  focusedDay: focusedDay.value,
                  calendarFormat: calendarFormat.value,
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDay.state, day);
                  },
                  onDaySelected: (selectedDayD, focusedDayD) {
                    if (!isSameDay(selectedDay.state, selectedDayD)) {
                      selectedDay.state = selectedDayD;
                      focusedDay.value = focusedDayD;
                    }
                  },
                  onFormatChanged: (format) {
                    if (calendarFormat.value != format) {
                      calendarFormat.value = format;
                    }
                  },
                  onPageChanged: (focusedDayD) {
                    focusedDay.value = focusedDayD;
                  },
                  eventLoader: (datetime) {
                    return hiveW.dayLists.ofDay(datetime).tasks.toList();
                  },
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: tasks.when(
                    data: (List<Task> value) {
                      final done =
                          value.where((element) => element.state!).length;

                      return Text('${value.length}/$done');
                    },
                    error: (Object error, StackTrace? stackTrace) =>
                        const Text('xxx'),
                    loading: () => const Text('...'),
                  ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Material(
                    elevation: 2,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) =>
                                  DialogTaskPanel(selectedDay.state),
                            );

                            ref.refresh(tasksProvider);
                          },
                          child: const Text('Add Task'),
                        ),
                      ],
                    ),
                  ),
                ),
                AddTaskItem(
                  dateTime: selectedDay.state,
                  afterAdd: () {
                    ref.refresh(tasksProvider);
                  },
                ),
                Expanded(
                  child: ProvideFutureList<Task>(
                    futureProvider: tasks,
                    itemBuilder: (context, task) {
                      return ProviderScope(
                        key: Key(task.title),
                        overrides: [
                          currentTask.overrideWithValue(task),
                          currentDay.overrideWithValue(
                            ref.read(dayListP.state).state,
                          ),
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
