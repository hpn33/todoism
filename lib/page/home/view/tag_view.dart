import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/tag_type.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoism/service/hive/type/task_type.dart';
import 'package:todoism/widget/styled_box.dart';

class TagView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final tags = hiveW.tags.all;

    useListenable(hiveW.tags.box.listenable());

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              StyledBox(
                title: 'tags',
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      for (final tag in tags) Text(tag.title),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: StyledBox(
            title: 'With detail',
            isList: true,
            child: ListView.builder(
              itemCount: tags.length,
              itemBuilder: (context, index) => item(tags.elementAt(index)),
            ),
          ),
        ),
        // Expanded(
        //   flex: 3,
        //   child: ListView.builder(
        //     itemCount: tags.length,
        //     itemBuilder: (context, index) => item(tags.elementAt(index)),
        //   ),
        // ),
      ],
    );
  }

  Widget item(Tag tag) {
    final tasks = tag.tasks;

    return Column(
      children: [
        Material(
          elevation: 6,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: tag.delete,
                    ),
                  ),
                  Text(tag.title),
                  Spacer(),
                  SizedBox(
                    width: 80,
                    child: Center(child: Text(tasks.length.toString())),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 1),
        Row(
          children: [
            SizedBox(width: 100),
            Expanded(
              child: Column(
                children: [
                  for (final task in tasks) taskItem(task),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget taskItem(Task task) {
    return Material(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(task.title),
      ),
    );
  }
}
