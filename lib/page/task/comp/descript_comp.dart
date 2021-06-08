import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/page/task/task_page.dart';

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
