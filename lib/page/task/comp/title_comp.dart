import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/page/task/task_page.dart';

class TitleComp extends HookConsumerWidget {
  const TitleComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final task = ref.watch(TaskPage.selectedTask.state).state;

    final state = useState(task.state!);

    final itemFocus = useFocusNode();
    useListenable(itemFocus);

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    final editMode = useState(false);

    return Focus(
      focusNode: itemFocus,
      onFocusChange: (focused) {
        if (focused) {
          return;
        }

        if (task.title == textEditingController.text) {
          editMode.value = false;
        }
      },
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    task.delete();
                    Navigator.pop(context);
                  },
                ),
                Checkbox(
                  // tristate: task.state == null ? true : false,
                  value: task.state ?? false,
                  onChanged: (v) {
                    task
                      ..state = v
                      ..save();

                    state.value = task.state!;
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (editMode.value) {
                  return;
                }

                textEditingController.text = task.title;
                editMode.value = true;
                itemFocus.requestFocus();
                textFieldFocusNode.requestFocus();
              },
              child: editMode.value
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
                          icon: const Icon(Icons.done),
                          onPressed: () {
                            if (task.title != textEditingController.text) {
                              task
                                ..title = textEditingController.text
                                ..save();
                            }

                            editMode.value = false;
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ],
                    )
                  : Text(
                      task.title,
                      style: const TextStyle(fontSize: 22),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
