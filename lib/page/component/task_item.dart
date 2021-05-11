import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/task_type.dart';
import 'package:hive_flutter/hive_flutter.dart';

final currentTask = ScopedProvider<Task>(null);

class TaskItem extends HookWidget {
  const TaskItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final task = useProvider(currentTask);

    final state = useState(task.state);

    final itemFocusNode = useFocusNode();
    // listen to focus chances
    useListenable(itemFocusNode);

    final titleTextEditingController = useTextEditingController();
    final titleTextFieldFocusNode = useFocusNode();

    return Card(
      child: Focus(
        focusNode: itemFocusNode,
        onFocusChange: (focused) {
          // print(focused);
          if (focused) {
            titleTextEditingController.text = task.title;
          } else {
            if (task.title != titleTextEditingController.text) {
              task.title = titleTextEditingController.text;
              task.save();
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
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

                      state.value = task.state;
                    },
                  ),
                  Expanded(
                    child: titleBuilder(
                      context,
                      task,
                      itemFocusNode,
                      titleTextFieldFocusNode,
                      titleTextEditingController,
                    ),
                  ),
                ],
              ),
              if (task.description.length > 1)
                Column(
                  children: [
                    Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('description'),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(task.description),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              // if (tags.isNotEmpty)
              tagsBuilder(task),
            ],
          ),
        ),
      ),
    );
  }

  Widget tagsBuilder(Task task) {
    return HookBuilder(
      builder: (BuildContext context) {
        final tagText = useTextEditingController();

        useListenable(hiveW.tags.box.listenable());

        return Column(
          children: [
            Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('tags'),
                SizedBox(width: 10),
                Wrap(
                  children: [
                    ...task.tags
                        .map(
                          (e) => ActionChip(
                            onPressed: () {},
                            label: Text(
                              e.title,
                            ),
                          ),
                        )
                        .toList(),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: tagText,
                        onSubmitted: (v) {
                          task.addTag(v);

                          tagText.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget titleBuilder(
    BuildContext context,
    Task task,
    FocusNode itemFocusNode,
    FocusNode titleTextFieldFocusNode,
    TextEditingController titleTextEditingController,
  ) {
    return GestureDetector(
      onTap: () {
        itemFocusNode.requestFocus();
        titleTextFieldFocusNode.requestFocus();
      },
      child: itemFocusNode.hasFocus
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: titleTextFieldFocusNode,
                    controller: titleTextEditingController,
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
    );
  }
}
