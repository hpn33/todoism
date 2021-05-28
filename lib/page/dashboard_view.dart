import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';

import 'component/task_item.dart';

class DashboardView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(child: oldTasks()),
          Expanded(child: todayTasks()),
          Expanded(child: commingTasks()),
        ],
      ),
    );
  }

  Widget oldTasks() {
    final dayLists = hiveW.dayLists.all
        .where((element) =>
            element.date.isBefore(DateTime.now().add(Duration(days: -1))))
        .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    return Column(
      children: [
        Text('Not Complete'),
        Divider(),
        Expanded(
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
                  Text(dayList.date.toString()),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return ProviderScope(
                        overrides: [
                          currentTask.overrideWithValue(tasks.elementAt(index)),
                        ],
                        child: TaskItem(mode: TaskItemMode.untilNow),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget todayTasks() {
    final tasks = hiveW.dayLists.ofDay(DateTime.now())!.tasks;

    return Column(
      children: [
        Text('To Day'),
        Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ProviderScope(
                overrides: [
                  currentTask.overrideWithValue(tasks.elementAt(index)),
                ],
                child: TaskItem(mode: TaskItemMode.simple),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget commingTasks() {
    final dayLists = hiveW.dayLists.all
        .where((element) => element.date.isAfter(DateTime.now()))
        .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    return Column(
      children: [
        Text('Comming'),
        Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: dayLists.length,
            itemBuilder: (context, index) {
              final dayList = dayLists.elementAt(index);
              final tasks = dayList.tasks;

              return Column(
                children: [
                  Text(dayList.date.toString()),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return ProviderScope(
                        overrides: [
                          currentTask.overrideWithValue(tasks.elementAt(index)),
                        ],
                        child: TaskItem(mode: TaskItemMode.untilNow),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
