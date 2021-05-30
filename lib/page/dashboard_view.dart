import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/page/component/add_task_item.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoism/service/hive/type/task_type.dart';

import 'component/task_item.dart';
import 'package:todoism/service/hive/type/day_list_type.dart';

class DashboardView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: oldTasks()),
        Container(width: 1, height: 300, color: Colors.grey),
        Expanded(child: todayTasks()),
        Container(width: 1, height: 300, color: Colors.grey),
        Expanded(child: commingTasks()),
      ],
    );
  }

  Widget oldTasks() {
    final dayLists = hiveW.dayLists.all
        .where((element) =>
            element.date.isBefore(DateTime.now().add(Duration(days: -1))))
        .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Old - Not Complete'),
          Divider(),
          Expanded(
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
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          return ProviderScope(
                            overrides: [
                              currentTask
                                  .overrideWithValue(tasks.elementAt(index)),
                            ],
                            child: TaskItem(mode: TaskItemMode.simple),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget todayTasks() {
    return HookBuilder(
      builder: (BuildContext context) {
        final tasks = () {
          final dayList = hiveW.dayLists.ofDay(DateTime.now());

          if (dayList == null) {
            return <Task>[];
          }

          return dayList.tasks;
        }();

        useListenable(hiveW.taskDayListRels.box.listenable());
        useListenable(hiveW.tasks.box.listenable());

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('To Day'),
              Divider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      AddTaskItem(
                        dateTime: DateTime.now(),
                        afterAdd: () {},
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            return ProviderScope(
                              overrides: [
                                currentTask
                                    .overrideWithValue(tasks.elementAt(index)),
                              ],
                              child: TaskItem(mode: TaskItemMode.simple),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget commingTasks() {
    final dayLists = hiveW.dayLists.all
        .where((element) => element.date.isAfter(DateTime.now()))
        .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Comming'),
          Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: dayLists.length,
                itemBuilder: (context, index) {
                  final dayList = dayLists.elementAt(index);
                  final tasks = dayList.tasks;

                  return Column(
                    children: [
                      header(dayList, Colors.blue),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          return ProviderScope(
                            overrides: [
                              currentTask
                                  .overrideWithValue(tasks.elementAt(index)),
                            ],
                            child: TaskItem(mode: TaskItemMode.simple),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding header(DayList dayList, MaterialColor color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Material(
        elevation: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dayList.date.toString()),
                  Text(
                    dayList.date.difference(DateTime.now()).inDays.toString(),
                  ),
                ],
              ),
            ),
            Container(color: color, height: 10),
          ],
        ),
      ),
    );
  }
}
