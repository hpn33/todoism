import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/page/home/component/add_task_item.dart';
import 'package:todoism/page/home/component/task_item.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoism/service/hive/type/task_type.dart';
import 'package:todoism/widget/provide_future_list.dart';

class TodoView extends HookWidget {
  final contentProvider = FutureProvider<List<Task>>(
    (ref) async {
      final tagIds = ref.watch(TagFilterComp.filtersProvider).state;
      final inner = ref.watch(TagFilterComp.innerProvider).state;

      final stateFilter = ref.watch(StateFilterComp.stateFilterP).state;

      final hasDateFilter = ref.watch(HasDateFilterComp.hasDateFilterP).state;

      final searchField = ref.watch(SearchFilterComp.searchProvider).state;

      var content = hiveW.tasks.all;

      if (hasDateFilter != null) {
        content = content
            .where((element) => element.dayLists.isNotEmpty == hasDateFilter);
      }

      if (stateFilter != null) {
        content = content.where((element) => element.state == stateFilter);
      }

      // tags
      if (tagIds.isNotEmpty) {
        content = content.where(
          (element) {
            final matchIds = element.taskTagRels
                .map((e) => e.tagId)
                .where((id) => tagIds.contains(id));

            if (!inner) {
              return matchIds.isNotEmpty;
            }

            return tagIds.length == matchIds.length;

            // var vals = tagIds.map((id) => matchIds.contains(id));

            // for (final val in vals) {
            //   if (!val) {
            //     return false;
            //   }
            // }

            // return true;
          },
        );
      }

      if (searchField.isNotEmpty) {
        content = content.where(
          (element) => element.title.contains(searchField),
        );
      }

      return content.toList().reversed.toList();
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
                HasDateFilterComp(),
                StateFilterComp(),
                TagFilterComp(),
                Card(
                  child: Center(
                    child: content.when(
                      data: (v) => Text('${v.length}'),
                      loading: () => CircularProgressIndicator(),
                      error: (e, s) => Text('$e\n$s'),
                    ),
                  ),
                ),
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
                          currentDay.overrideWithValue(null),
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
  static final stateFilterP = StateProvider<bool?>((ref) => null);

  @override
  Widget build(BuildContext context) {
    final stateFilter = useProvider(stateFilterP);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('State'),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio<bool?>(
                        value: null,
                        groupValue: stateFilter.state,
                        onChanged: (v) {
                          stateFilter.state = v;
                        },
                      ),
                      Text('All'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<bool?>(
                        value: true,
                        groupValue: stateFilter.state,
                        onChanged: (v) {
                          stateFilter.state = v;
                        },
                      ),
                      Text('Done'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<bool?>(
                        value: false,
                        groupValue: stateFilter.state,
                        onChanged: (v) {
                          stateFilter.state = v;
                        },
                      ),
                      Text('Not'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HasDateFilterComp extends HookWidget {
  static final hasDateFilterP = StateProvider<bool?>((ref) => null);

  @override
  Widget build(BuildContext context) {
    final hasDateFilter = useProvider(hasDateFilterP);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('Has Date'),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio<bool?>(
                        value: null,
                        groupValue: hasDateFilter.state,
                        onChanged: (v) {
                          hasDateFilter.state = v;
                        },
                      ),
                      Text('All'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<bool?>(
                        value: true,
                        groupValue: hasDateFilter.state,
                        onChanged: (v) {
                          hasDateFilter.state = v;
                        },
                      ),
                      Text('InTime'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<bool?>(
                        value: false,
                        groupValue: hasDateFilter.state,
                        onChanged: (v) {
                          hasDateFilter.state = v;
                        },
                      ),
                      Text('Not'),
                    ],
                  ),
                ],
              ),
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
