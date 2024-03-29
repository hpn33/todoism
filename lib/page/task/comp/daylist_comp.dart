import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/page/task/task_page.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/widget/styled_box.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoism/util/date_extention.dart';

class DayListComp extends HookConsumerWidget {
  const DayListComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final task = ref.watch(TaskPage.selectedTask.state).state;
    final dayLists = task.dayLists.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    useListenable(hiveW.taskDayListRels.box.listenable());

    return StyledBox(
      title: 'dayList',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                        'Old (${dayLists.last.diff}) ${dayLists.last.diffForHuman}'),
                    const SizedBox(width: 15),
                    Text(
                        'Last (${dayLists.first.diff}) ${dayLists.first.diffForHuman}'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().add(const Duration(days: -365)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );

                        if (pickedDate == null) {
                          return;
                        }

                        await task.addToDayList(pickedDate);
                      },
                    ),
                    if (task.dayLists
                        .where((element) =>
                            element.date == DateTime.now().justDate())
                        .isEmpty)
                      TextButton(
                        child: const Text('Add To Today'),
                        onPressed: () {
                          task.addToDayList(DateTime.now());
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: dayLists.length,
              itemBuilder: (context, index) {
                final dayList = dayLists[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: dayList.isToday
                        ? BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          )
                        : null,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => task.removeFromThisDay(dayList),
                        ),
                        const SizedBox(width: 10),
                        Text(dayList.date.toString()),
                        const SizedBox(width: 10),
                        Text(dayList.diff.toString()),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
