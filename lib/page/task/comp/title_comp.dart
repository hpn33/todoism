import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/page/task/task_page.dart';

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
