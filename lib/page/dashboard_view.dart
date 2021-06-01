import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todoism/page/component/add_task_item.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'component/task_item.dart';
import 'package:todoism/service/hive/type/day_list_type.dart';

class DashboardView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        children: [
          StatusCard(),
          Expanded(
            child: Row(
              children: [
                Expanded(child: oldTasks()),
                Container(width: 1, height: 300, color: Colors.grey),
                Expanded(child: todayTasks()),
                Container(width: 1, height: 300, color: Colors.grey),
                Expanded(child: commingTasks()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget oldTasks() {
    final dayLists = hiveW.dayLists.before(
      DateTime.now().add(Duration(days: -1)),
    );

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
        final daylist = hiveW.dayLists.ofDay(DateTime.now());
        final tasks = daylist.tasks;

        useListenable(hiveW.taskDayListRels.box.listenable());
        useListenable(hiveW.tasks.box.listenable());

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              AddTaskItem(
                dateTime: DateTime.now(),
                afterAdd: () {},
              ),
              header(daylist, Colors.purple),
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
          ),
        );
      },
    );
  }

  Widget commingTasks() {
    final dayLists = hiveW.dayLists.after(DateTime.now());

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
                  final dayList = dayLists[index];
                  final tasks = dayList.tasks;

                  if (tasks.isEmpty) {
                    return SizedBox();
                  }

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
    final diff =
        ((dayList.date.difference(DateTime.now()).inHours / 24.0) + 0.5)
            .round();

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
              if (diff != 0)
                Text(
                  diff.toInt().toString(),
                  style: TextStyle(color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = hiveW.tasks.all;
    final done = tasks.where((element) => element.state == true);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            item('All', tasks.length, Colors.blue),
            item('Done', done.length, Colors.green),
            item('Not', tasks.length - done.length, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget item(String text, int number, Color color) {
    return Row(
      children: [
        Text(text),
        SizedBox(width: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: color,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Text(
            number.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
