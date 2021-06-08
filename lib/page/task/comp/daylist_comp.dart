import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/page/task/task_page.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/widget/styled_box.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DayListComp extends HookWidget {
  const DayListComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final task = useProvider(TaskPage.selectedTask).state;
    final dayLists = task.dayLists;

    useListenable(hiveW.taskDayListRels.box.listenable());

    return StyledBox(
      title: 'dayList',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: (dayLists.toList()
                    ..sort(
                      (a, b) => a.date.compareTo(b.date),
                    ))
                  .map(
                (dayList) {
                  final diff =
                      ((dayList.date.difference(DateTime.now()).inHours /
                                  24.0) +
                              0.5)
                          .round();

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () => dayList.delete(),
                        ),
                        SizedBox(width: 10),
                        Text(dayList.date.toString()),
                        SizedBox(width: 10),
                        Text(diff.toString()),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().add(Duration(days: -365)),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );

                  if (pickedDate == null) {
                    return;
                  }

                  await task.addToDayList(pickedDate);
                },
              ),
              TextButton(
                child: Text('today'),
                onPressed: () {
                  task.addToDayList(DateTime.now());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
