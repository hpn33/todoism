import 'package:flutter/material.dart';
import 'package:todoism/service/hive/type/task_type.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tags = task.tags;

    return Card(
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
                  },
                ),
                Text(
                  task.title,
                  style: TextStyle(fontSize: 22),
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
                      Text(task.description),
                    ],
                  ),
                ],
              ),
            if (tags.isNotEmpty)
              Column(
                children: [
                  Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('tags'),
                      SizedBox(width: 10),
                      Wrap(
                        children: tags.map((e) => Text(e.title)).toList(),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
