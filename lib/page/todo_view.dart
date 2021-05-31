import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoism/service/hive/type/task_type.dart';
import 'package:todoism/widget/provide_future_list.dart';

import 'component/add_task_item.dart';
import 'component/task_item.dart';

class TodoView extends HookWidget {
  final contentProvider = FutureProvider<List<Task>>(
    (ref) async {
      final tagIds = ref.watch(TagFilterComp.filtersProvider).state;
      final inner = ref.watch(TagFilterComp.innerProvider).state;

      final all = ref.watch(StateFilterComp.allProvider).state;
      final completed = ref.watch(StateFilterComp.completedProvider).state;

      final searchField = ref.watch(SearchFilterComp.searchProvider).state;

      var content = hiveW.tasks.byTags(tagIds, inner: inner);

      if (!all) {
        content = content.where((element) => element.state == completed);
      }

      if (searchField.isNotEmpty) {
        content = content.where(
          (element) => element.title.contains(searchField),
        );
      }

      return content.toList();
    },
  );

  @override
  Widget build(BuildContext context) {
    useListenable(hiveW.tasks.box.listenable());

    final content = useProvider(contentProvider);

    return Row(
      children: [
        Expanded(
          child: Scrollbar(
            child: ListView(
              children: [
                SearchFilterComp(),
                StateFilterComp(),
                TagFilterComp(),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                AddTaskItem(),
                Expanded(
                  child: ProvideFutureList<Task>(
                    futureProvider: content,
                    itemBuilder: (context, task) {
                      return ProviderScope(
                        key: Key(task.title),
                        overrides: [
                          currentTask.overrideWithValue(task),
                        ],
                        child: TaskItem(key: Key(task.title)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SearchFilterComp extends HookWidget {
  static final searchProvider = StateProvider((ref) => '');

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();

    return Card(
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
                  context.read(searchProvider).state = v;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StateFilterComp extends HookWidget {
  static final allProvider = StateProvider((ref) => true);
  static final completedProvider = StateProvider((ref) => false);

  @override
  Widget build(BuildContext context) {
    // state
    final all = useProvider(allProvider);
    final completed = useProvider(completedProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('State'),
            Checkbox(
              value: all.state,
              onChanged: (v) {
                all.state = v!;
              },
            ),
            Text('All'),
            if (!all.state)
              Row(
                children: [
                  Checkbox(
                    value: completed.state,
                    onChanged: (v) => completed.state = v!,
                  ),
                  Text('Completed'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class TagFilterComp extends HookWidget {
  static final filtersProvider = StateProvider((ref) => <int>[]);
  static final innerProvider = StateProvider((ref) => false);

  @override
  Widget build(BuildContext context) {
    final tags = hiveW.tags.all;

    useListenable(hiveW.tags.box.listenable());

    // tag
    final filters = useProvider(filtersProvider);
    final inner = useProvider(innerProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: inner.state,
                  onChanged: (bool? value) {
                    inner.state = value!;
                  },
                ),
                Text('Inner'),
              ],
            ),
            Divider(),
            Wrap(
              children: tags
                  .map(
                    (tag) => FilterChip(
                      selected: filters.state
                          .where((element) => element == tag.key)
                          .isNotEmpty,
                      label: Text(tag.title),
                      onSelected: (bool value) {
                        if (value) {
                          if (filters.state
                              .where((element) => element == tag.key)
                              .isEmpty) {
                            filters.state = [
                              ...filters.state,
                              tag.key,
                            ];
                          }

                          return;
                        }

                        if (filters.state
                            .where((element) => element == tag.key)
                            .isNotEmpty) {
                          filters.state = [
                            ...filters.state..remove(tag.key),
                          ];
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
