import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/page/task/task_page.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/day_list_type.dart';
import 'package:todoism/service/hive/type/task_type.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum TaskItemMode {
  simple,
  normal,
}

final currentTask = Provider<Task>((ref) => Task());
final currentDay = Provider<DayList?>((ref) => DayList());

class TaskItem extends HookConsumerWidget {
  const TaskItem({Key? key, this.mode}) : super(key: key);

  final TaskItemMode? mode;

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: ContextMenuRegion(
        contextMenu: menuOptions(context, ref),
        child: InkWell(
          onTap: () {
            ref.read(TaskPage.selectedTask).state = ref.read(currentTask).state;

            showDialog(
              context: context,
              builder: (context) => const TaskPage(),
            );
          },
          child: Material(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  TitleComp(),
                  DescriptionComp(),
                  TagComp(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget menuOptions(BuildContext context, ref) {
    final task = ref.read(currentTask);
    final dayList = ref.read(currentDay);

    return GenericContextMenu(
      buttonConfigs: [
        ContextMenuButtonConfig(
          "Open",
          onPressed: () {
            ref.read(TaskPage.selectedTask).state = ref.read(currentTask);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TaskPage()),
            );
          },
        ),
        if (!task.hasToday)
          ContextMenuButtonConfig(
            "Add to Today",
            onPressed: () => task.addtoToday(),
          ),
        if (dayList != null)
          ContextMenuButtonConfig(
            "Remove From This Day",
            onPressed: () => task.removeFromThisDay(dayList),
          ),
        ContextMenuButtonConfig(
          "Delete",
          onPressed: () => ref.read(currentTask).delete(),
        ),
      ],
    );
  }
}

class TitleComp extends HookConsumerWidget {
  const TitleComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final task = ref.watch(currentTask);

    final state = useState(task.state!);

    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Row(
            children: [
              Checkbox(
                value: task.state ?? false,
                onChanged: (v) {
                  task.state = v;
                  task.save();

                  state.value = task.state!;
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            task.title,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class DescriptionComp extends HookConsumerWidget {
  const DescriptionComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final task = ref.watch(currentTask);

    if (task.description.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 50),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(task.description),
            ),
          ),
        ],
      ),
    );
  }
}

class TagComp extends HookConsumerWidget {
  const TagComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final task = ref.watch(currentTask);

    useListenable(hiveW.tags.box.listenable());
    useListenable(hiveW.taskTagRels.box.listenable());

    if (task.tags.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        children: task.tags
            .map(
              (e) => ActionChip(
                onPressed: () {},
                label: Text(e.title),
              ),
            )
            .toList(),
      ),
    );
  }
}
