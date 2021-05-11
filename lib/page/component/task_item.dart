import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/tag_type.dart';
import 'package:todoism/service/hive/type/task_type.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
            tagsBuilder(tags),
          ],
        ),
      ),
    );
  }

  Widget tagsBuilder(Iterable<Tag> tags) {
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
                    ...tags
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
}
