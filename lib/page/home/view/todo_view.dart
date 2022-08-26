import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/page/home/component/add_task_item.dart';
import 'package:todoism/page/home/component/task_item.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoism/service/hive/type/task_type.dart';
import 'package:todoism/widget/provide_future_list.dart';

class TodoView extends HookConsumerWidget {
  final contentProvider = FutureProvider<List<Task>>(
    (ref) async {
      final tagIds = ref.watch(TagFilterComp.filtersProvider.state).state;
      final inner = ref.watch(TagFilterComp.innerProvider.state).state;

      final stateFilter = ref.watch(StateFilterComp.stateFilterP.state).state;

      final hasDateFilter =
          ref.watch(HasDateFilterComp.hasDateFilterP.state).state;

      final searchField =
          ref.watch(SearchFilterComp.searchProvider.state).state;

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

  TodoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    useListenable(hiveW.tasks.box.listenable());

    final content = ref.watch(contentProvider);

    return Row(
      children: [
        Expanded(
          child: Scrollbar(
            child: ListView(
              children: [
                const SearchFilterComp(),
                const HasDateFilterComp(),
                const StateFilterComp(),
                const TagFilterComp(),
                Card(
                  child: Center(
                    child: content.when(
                      data: (v) => Text('${v.length}'),
                      loading: () => const CircularProgressIndicator(),
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
                const AddTaskItem(),
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

class SearchFilterComp extends HookConsumerWidget {
  static final searchProvider = StateProvider((ref) => '');

  const SearchFilterComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final searchController = useTextEditingController();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Text('Search'),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: searchController,
                onChanged: (v) {
                  ref.read(searchProvider.state).state = v;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StateFilterComp extends HookConsumerWidget {
  static final stateFilterP = StateProvider<bool?>((ref) => null);

  const StateFilterComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final stateFilter = ref.watch(stateFilterP.state);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Text('State'),
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
                      const Text('All'),
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
                      const Text('Done'),
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
                      const Text('Not'),
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

class HasDateFilterComp extends HookConsumerWidget {
  static final hasDateFilterP = StateProvider<bool?>((ref) => null);

  const HasDateFilterComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final hasDateFilter = ref.watch(hasDateFilterP.state);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Text('Has Date'),
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
                      const Text('All'),
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
                      const Text('InTime'),
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
                      const Text('Not'),
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

class TagFilterComp extends HookConsumerWidget {
  static final filtersProvider = StateProvider((ref) => <int>[]);
  static final innerProvider = StateProvider((ref) => false);

  const TagFilterComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final tags = hiveW.tags.all;

    useListenable(hiveW.tags.box.listenable());

    // tag
    final filters = ref.watch(filtersProvider.state);
    final inner = ref.watch(innerProvider.state);

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
                const Text('Inner'),
              ],
            ),
            const Divider(),
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
