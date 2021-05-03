import 'package:flutter/material.dart';
import 'package:todoism/service/hive/type/task_type.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                tristate: task.state == null ? true : false,
                value: task.state,
                onChanged: (v) {},
              ),
              Text(
                task.title,
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
          Text(task.description),
        ],
      ),
    );
  }
}
