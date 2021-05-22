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
    // state
    final all = useState(true);
    final completed = useState(false);
    final showComplete = useState(false);

    // search
    final searchField = useState('');
    final searchController = useTextEditingController();

    // tag
    final filters = useState(<int>[]);
    final inner = useState(false);

    useListenable(hiveW.tasks.box.listenable());
    useListenable(hiveW.tags.box.listenable());

    final tags = hiveW.tags.all;

    final content = createContent(
      all.value,
      completed.value,
      searchField.value,
      filters.value,
      inner.value,
    );

    return Row(
      children: [
        Expanded(
          child: Scrollbar(
            child: ListView(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('Search'),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onChanged: (v) {
                              searchField.value = v;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('State'),
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: inner.value,
                              onChanged: (bool? value) {
                                inner.value = value!;
                              },
                            ),
                            Text('Inner'),
                          ],
                        ),
                        Divider(),
                        Wrap(
                          children: [
                            ...tags
                                .map(
                                  (tag) => FilterChip(
                                    selected: filters.value
                                        .where((element) => element == tag.key)
                                        .isNotEmpty,
                                    label: Text(tag.title),
                                    onSelected: (bool value) {
                                      if (value) {
                                        if (filters.value
                                            .where(
                                                (element) => element == tag.key)
                                            .isEmpty) {
                                          filters.value = [
                                            ...filters.value,
                                            tag.key,
                                          ];
                                        }

                                        return;
                                      }

                                      if (filters.value
                                          .where(
                                              (element) => element == tag.key)
                                          .isNotEmpty) {
                                        filters.value = [
                                          ...filters.value..remove(tag.key),
                                        ];
                                      }
                                    },
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
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

  List<ProviderScope> createContent(
    bool all,
    bool completed,
    String searchField,
    List<int> tagIds,
    bool inner,
  ) {
    var content = hiveW.tasks.byTags(tagIds, inner: inner);

    if (!all) {
      content = content.where((element) => element.state == completed);
    }

    if (searchField.isNotEmpty) {
      content = content.where((element) => element.title == searchField);
    }

    return content.map(
      (task) {
        return ProviderScope(
          overrides: [
            currentTask.overrideWithValue(task),
          ],
          child: const TaskItem(),
        );
      },
    ).toList();
  }
}
