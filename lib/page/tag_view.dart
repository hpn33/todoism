import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'component/task_item.dart';

class TagView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final filters = useState(<int>[]);

    useListenable(hiveW.tasks.box.listenable());
    useListenable(hiveW.tags.box.listenable());

    final tags = hiveW.tags.all;

    final filteredTask = hiveW.tasks.byFilter(filters.value);

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                                .where((element) => element == tag.key)
                                .isEmpty) {
                              filters.value = [
                                ...filters.value,
                                tag.key,
                              ];
                            }

                            return;
                          }

                          if (filters.value
                              .where((element) => element == tag.key)
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
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...filteredTask.map((e) => TaskItem(task: e)).toList(),
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
