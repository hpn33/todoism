import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'component/add_task_item.dart';
import 'component/task_item.dart';

class TodoView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useListenable(hiveW.tasks.box.listenable());
    final all = useState(true);
    final completed = useState(false);
    final showComplete = useState(false);

    // final searchField = useState('');
    // final searchController = useTextEditingController(text: '');

    final content = createContent(all.value, completed.value, ''
        // searchField.value,
        );

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
                // SizedBox(width: 30),
                // Text('Search'),
                // SizedBox(width: 10),
                // Expanded(
                //   child: TextField(
                //     controller: searchController,
                //     onChanged: (v) {
                //       searchController.text = v;
                //       searchField.value = v;
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: content.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return AddTaskItem();
                  }

                  return content[index - 1];
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  createContent(bool all, bool completed, String searchField) {
    var content = hiveW.tasks.all;

    if (!all) {
      content = content.where((element) => element.state == completed);
    }

    if (searchField.isNotEmpty) {
      content = content.where((element) => element.title == searchField);
    }

    return content
        .map(
          (task) {
            return ProviderScope(
              overrides: [
                currentTask.overrideWithValue(task),
              ],
              child: const TaskItem(),
            );
          },
        )
        .toList()
        .reversed
        .toList();
  }
}
