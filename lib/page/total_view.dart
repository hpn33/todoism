import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:todoism/page/component/task_item.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TotalView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useListenable(hiveW.tasks.box.listenable());
    final all = useState(true);
    final completed = useState(false);
    final showComplete = useState(false);

    final content = hiveW.dayLists.sorted().map(
      (dayList) {
        if (dayList.tasks().isEmpty) {
          return SizedBox();
        }

        return Column(
          children: [
            Text(DateFormat.yMd().format(dayList.date)),
            Divider(),
            ...dayList.tasks().map((task) {
              if (!all.value) {
                if (task.state != completed.value) {
                  return SizedBox();
                }
              }

              return TaskItem(task: task);
            })
          ],
        );
      },
    ).toList();

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Filter'),
                Checkbox(
                  value: all.value,
                  onChanged: (v) {
                    all.value = v!;
                    showComplete.value = v;
                  },
                ),
                Text('All'),
                if (!all.value)
                  Row(
                    children: [
                      Checkbox(
                        value: completed.value,
                        onChanged: (v) => completed.value = v!,
                      ),
                      Text('Completed'),
                    ],
                  ),
              ],
            ),
          ),
        ),
        Scrollbar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: content,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
