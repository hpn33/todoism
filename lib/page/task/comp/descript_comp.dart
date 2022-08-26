import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/page/task/task_page.dart';

class DescriptionComp extends HookConsumerWidget {
  const DescriptionComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final task = ref.watch(TaskPage.selectedTask.state).state;

    final itemFocus = useFocusNode();
    useListenable(itemFocus);

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    final editMode = useState(false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Focus(
        focusNode: itemFocus,
        onFocusChange: (focused) {
          if (focused) {
            return;
          }

          if (task.description == textEditingController.text) {
            editMode.value = false;
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // content
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (editMode.value) {
                    return;
                  }

                  textEditingController.text = task.description;
                  editMode.value = true;
                  itemFocus.requestFocus();
                  textFieldFocusNode.requestFocus();
                },
                child: Container(
                  padding: (editMode.value ||
                          itemFocus.hasFocus ||
                          task.description.isNotEmpty)
                      ? const EdgeInsets.all(8)
                      : null,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: editMode.value
                      ? Stack(
                          children: [
                            TextField(
                              autofocus: true,
                              focusNode: textFieldFocusNode,
                              controller: textEditingController,
                              minLines: 3,
                              maxLines: 10,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: const Icon(Icons.done),
                                onPressed: () {
                                  if (task.description !=
                                      textEditingController.text) {
                                    task
                                      ..description = textEditingController.text
                                      ..save();
                                  }

                                  editMode.value = false;
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                            ),
                          ],
                        )
                      : task.description.isNotEmpty
                          ? Text(task.description)
                          : const Icon(Icons.add, size: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
