import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'component/task_item.dart';

class DayView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final dateTime = useState(DateTime.now());

    useListenable(hiveW.tasks.box.listenable());

    final tasks = [];
    final dayList = hiveW.dayLists.ofDay(dateTime.value);
    if (dayList != null) {
      tasks.addAll(dayList.tasks);
    }

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    dateTime.value = dateTime.value.add(Duration(days: -1));
                  },
                  child: Text('<'),
                ),
                TextButton(
                  child: Text(DateFormat.yMd().format(dateTime.value)),
                  onPressed: () async {
                    final time = await showDatePicker(
                      context: context,
                      initialDate: dateTime.value,
                      firstDate: DateTime.now().add(Duration(days: -365)),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );

                    if (time != null) {
                      dateTime.value = time;
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    dateTime.value = dateTime.value.add(Duration(days: 1));
                  },
                  child: Text('>'),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // AddTaskItem(),
                    ...tasks.map((task) => TaskItem(task: task)).toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AddTaskItem extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final titleText = useTextEditingController();

    return Card(
      child: Row(
        children: [
          Expanded(child: TextField(controller: titleText)),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              // hiveW.addTask(titleText.text);
            },
          ),
        ],
      ),
    );
  }
}
