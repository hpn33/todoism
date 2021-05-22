import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/task_type.dart';

final taskTemp = Provider((ref) => Task());

class AddTaskItem extends HookWidget {
  const AddTaskItem({this.dateTime, Key? key}) : super(key: key);

  final DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Padding(
      padding: const EdgeInsets.only(bottom: 36.0),
      child: Material(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Center(child: Text('Add')),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    textFieldFocusNode.requestFocus();
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          focusNode: textFieldFocusNode,
                          controller: textEditingController,
                          onSubmitted: (v) =>
                              addTask(context, textEditingController),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.done),
                        onPressed: () =>
                            addTask(context, textEditingController),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTask(
    BuildContext context,
    TextEditingController textEditingController,
  ) {
    hiveW.addTaskQuick(textEditingController.text, date: dateTime);
    FocusScope.of(context).unfocus();
    textEditingController.clear();
  }
}