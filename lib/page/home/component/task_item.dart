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

final currentTask = ScopedProvider<Task>(null);
final currentDay = ScopedProvider<DayList?>(null);

class TaskItem extends HookWidget {
  const TaskItem({Key? key, this.mode}) : super(key: key);

  final TaskItemMode? mode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: ContextMenuRegion(
        contextMenu: menuOptions(context),
        child: InkWell(
          onTap: () {
            context.read(TaskPage.selectedTask).state =
                context.read(currentTask);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskPage()),
            );
          },
          child: Material(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TitleComp(),
                  SizedBox(height: 10),
                  DescriptionComp(),
                  SizedBox(height: 10),
                  TagComp(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget menuOptions(BuildContext context) {
    final task = context.read(currentTask);
    final dayList = context.read(currentDay);

    return GenericContextMenu(
      buttonConfigs: [
        ContextMenuButtonConfig(
          "Open",
          onPressed: () {
            context.read(TaskPage.selectedTask).state =
                context.read(currentTask);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskPage()),
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
          onPressed: () => context.read(currentTask).delete(),
        ),
      ],
    );
  }
}

class TitleComp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final task = useProvider(currentTask);

    final state = useState(task.state!);

    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Row(
            children: [
              Checkbox(
                value: task.state == null ? false : task.state,
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
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class DescriptionComp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final task = useProvider(currentTask);

    if (task.description.isEmpty) {
      return SizedBox();
    }
    return Row(
      children: [
        SizedBox(width: 50),
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
    );
  }
}

class TagComp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final task = useProvider(currentTask);

    useListenable(hiveW.tags.box.listenable());
    useListenable(hiveW.taskTagRels.box.listenable());

    return Wrap(
      children: task.tags
          .map(
            (e) => ActionChip(
              onPressed: () {},
              label: Text(e.title),
            ),
          )
          .toList(),
    );
  }
}
