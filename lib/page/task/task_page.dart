import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/widget/main_frame.dart';
import 'package:todoism/widget/styled_box.dart';

class TaskPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final task = hiveW.tasks.all.elementAt(0);

    return MainFrame(
      child: Container(
        color: Colors.grey[300],
        child: Column(
          children: [
            BackButton(),
            StyledBox(
              title: 'detail',
              child: Column(
                children: [
                  Text(task.title),
                  Text(task.description),
                  Text(task.state.toString()),
                ],
              ),
            ),
            StyledBox(
              title: 'tags',
              child: Column(
                children: [
                  for (final tag in task.tags) Text(tag.title),
                ],
              ),
            ),
            StyledBox(
              title: 'dayList',
              child: Column(
                children: [
                  for (final daylist in task.dayLists)
                    Text(daylist.date.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
