import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todoism/page/home/component/add_task_item.dart';
import 'package:todoism/page/home/component/task_item.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoism/widget/styled_box.dart';

import 'package:todoism/service/hive/type/day_list_type.dart';

class DashboardView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: oldTasks()),
                Expanded(child: todayTasks()),
                Expanded(child: commingTasks()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget oldTasks() {
    return HookBuilder(
      builder: (BuildContext context) {
        final dayLists = hiveW.dayLists.before(
          DateTime.now().add(Duration(days: -1)),
        );

        useListenable(hiveW.taskDayListRels.box.listenable());
        useListenable(hiveW.tasks.box.listenable());

        final taskCount = dayLists
            .map((e) => e.tasks)
            .reduce((value, element) => [...value, ...element])
            .where((e) => e.state == false)
            .length;

        return StyledBox(
          title: 'Old - Not Complete ( Count $taskCount )',
          isList: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: dayLists.length,
              itemBuilder: (context, index) {
                final dayList = dayLists.elementAt(index);
                final tasks =
                    dayList.tasks.where((element) => element.state == false);

                if (tasks.isEmpty) {
                  return SizedBox();
                }

                return Column(
                  children: [
                    header(dayList, Colors.blueGrey),
                    Column(
                      children: [
                        for (final task in tasks)
                          ProviderScope(
                            key: Key(task.key.toString()),
                            overrides: [
                              currentTask.overrideWithValue(task),
                            ],
                            child: TaskItem(mode: TaskItemMode.simple),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget todayTasks() {
    return HookBuilder(
      builder: (BuildContext context) {
        final daylist = hiveW.dayLists.ofDay(DateTime.now());
        final tasks = daylist.tasks;

        useListenable(hiveW.taskDayListRels.box.listenable());
        useListenable(hiveW.tasks.box.listenable());

        final unpassedTask = tasks.where((element) => element.state!).length;

        return StyledBox(
          isList: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AddTaskItem(
                  dateTime: DateTime.now(),
                  afterAdd: () {},
                ),
                Text('${tasks.length} / $unpassedTask'),
                header(daylist, Colors.purple),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks.elementAt(index);

                      return ProviderScope(
                        key: Key(task.key.toString()),
                        overrides: [
                          currentTask.overrideWithValue(task),
                        ],
                        child: TaskItem(mode: TaskItemMode.simple),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget commingTasks() {
    return HookBuilder(
      builder: (BuildContext context) {
        final dayLists = hiveW.dayLists.after(DateTime.now());

        useListenable(hiveW.taskDayListRels.box.listenable());
        useListenable(hiveW.tasks.box.listenable());

        final taskCount = dayLists
            .map((e) => e.tasks)
            .reduce((value, element) => [...value, ...element])
            .where((e) => e.state == false)
            .length;

        return StyledBox(
          title: 'Comming ( Count $taskCount )',
          isList: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: dayLists.length,
              itemBuilder: (context, index) {
                final dayList = dayLists[index];
                final tasks = dayList.tasks;

                if (tasks.isEmpty) {
                  return SizedBox();
                }

                return Column(
                  children: [
                    header(dayList, Colors.blue),
                    Column(
                      children: [
                        for (final task in tasks)
                          ProviderScope(
                            key: Key(task.key.toString()),
                            overrides: [
                              currentTask.overrideWithValue(task),
                            ],
                            child: TaskItem(mode: TaskItemMode.simple),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Padding header(DayList dayList, MaterialColor color) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Material(
        color: color,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat.yMd().format(dayList.date),
                style: TextStyle(color: Colors.white),
              ),
              Text(
                [
                  if (dayList.diff.sign == -1) '${dayList.diffForHuman} ',
                  '(${dayList.diff})',
                  if (dayList.diff.sign == 1) ' day',
                ].join(),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
