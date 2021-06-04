import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/day_list_type.dart';
import 'package:todoism/service/hive/type/task_type.dart';
import 'package:todoism/widget/main_frame.dart';
import 'package:todoism/widget/styled_box.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TaskPage extends HookWidget {
  static final selectedTask = StateProvider((ref) => Task());

  @override
  Widget build(BuildContext context) {
    final task = useProvider(selectedTask).state;

    useListenable(hiveW.taskDayListRels.box.listenable());

    return MainFrame(
      child: Container(
        color: Colors.grey[300],
        child: Column(
          children: [
            BackButton(),
            StyledBox(
              title: 'detail',
              child: Column(
                children: [
                  Text(task.title),
                  Text(task.description),
                  Text(task.state.toString()),
                ],
              ),
            ),
            StyledBox(
              title: 'tags',
              child: Column(
                children: [
                  for (final tag in task.tags) Text(tag.title),
                ],
              ),
            ),
            dayListBuild(task.dayLists),
          ],
        ),
      ),
    );
  }

  Widget dayListBuild(Iterable<DayList> dayLists) {
    return StyledBox(
      title: 'dayList',
      child: Column(
        children: (dayLists.toList()
              ..sort(
                (a, b) => a.date.compareTo(b.date),
              ))
            .map(
          (dayList) {
            final diff =
                ((dayList.date.difference(DateTime.now()).inHours / 24.0) + 0.5)
                    .round();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
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
    );
  }
}
