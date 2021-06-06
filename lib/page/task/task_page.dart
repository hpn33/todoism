import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  BackButton(),
                  Expanded(child: TitleComp()),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      StyledBox(
                        title: 'detail',
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DescriptionComp(),
                        ),
                      ),
                      dayListBuild(context, task),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      StyledBox(
                        title: 'tags',
                        child: Column(
                          children: [
                            for (final tag in task.tags) Text(tag.title),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dayListBuild(BuildContext context, Task task) {
    final dayLists = task.dayLists;

    return HookBuilder(
      builder: (BuildContext context) {
        useListenable(hiveW.taskDayListRels.box.listenable());

        return StyledBox(
          title: 'dayList',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: (dayLists.toList()
                        ..sort(
                          (a, b) => a.date.compareTo(b.date),
                        ))
                      .map(
                    (dayList) {
                      final diff =
                          ((dayList.date.difference(DateTime.now()).inHours /
                                      24.0) +
                                  0.5)
                              .round();

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.clear),
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
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().add(Duration(days: -365)),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );

                      if (pickedDate == null) {
                        return;
                      }

                      await task.addToDayList(pickedDate);
                    },
                  ),
                  TextButton(
                    child: Text('today'),
                    onPressed: () {
                      task.addToDayList(DateTime.now());
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class TitleComp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final task = useProvider(TaskPage.selectedTask).state;

    final state = useState(task.state!);

    final itemFocus = useFocusNode();
    useListenable(itemFocus);

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Focus(
      focusNode: itemFocus,
      onFocusChange: (focused) {
        if (focused) {
          textEditingController.text = task.title;
        } else {
          if (task.title != textEditingController.text) {
            task.title = textEditingController.text;
            task.save();
          }
        }
      },
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    task.delete();
                  },
                ),
                Checkbox(
                  // tristate: task.state == null ? true : false,
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
            child: GestureDetector(
              onTap: () {
                itemFocus.requestFocus();
                textFieldFocusNode.requestFocus();
              },
              child: itemFocus.hasFocus
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            focusNode: textFieldFocusNode,
                            controller: textEditingController,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.done),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ],
                    )
                  : Text(
                      task.title,
                      style: TextStyle(fontSize: 22),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class DescriptionComp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final task = useProvider(TaskPage.selectedTask).state;

    final itemFocus = useFocusNode();
    useListenable(itemFocus);

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Focus(
      focusNode: itemFocus,
      onFocusChange: (focused) {
        if (focused) {
          textEditingController.text = task.description;
        } else {
          if (task.description != textEditingController.text) {
            task.description = textEditingController.text;
            task.save();
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          itemFocus.requestFocus();
          textFieldFocusNode.requestFocus();
        },
        child: itemFocus.hasFocus
            ? Stack(
                children: [
                  TextField(
                    autofocus: true,
                    focusNode: textFieldFocusNode,
                    controller: textEditingController,
                    minLines: 1,
                    maxLines: 10,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ],
              )
            : task.description.length > 0
                ? Text(task.description)
                : InkWell(
                    child: Icon(Icons.add, size: 18),
                  ),
      ),
    );
  }
}
