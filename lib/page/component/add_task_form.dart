import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';

class AddTaskForm extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final titleText = useTextEditingController();
    final descriptText = useTextEditingController();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Task',
                  style: TextStyle(fontSize: 22),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    hiveW.addTask(
                      titleText.text,
                      descriptText.text,
                    );

                    titleText.clear();
                    descriptText.clear();
                  },
                ),
              ],
            ),
            Divider(),
            Text('Title'),
            TextField(
              controller: titleText,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            Text('Desc'),
            TextField(
              controller: descriptText,
              decoration: InputDecoration(border: OutlineInputBorder()),
              minLines: 3,
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
