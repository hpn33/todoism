import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';

class MainFrame extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final task = hiveW.tasks.all.elementAt(0);

    return Column(
      children: [
        Text(task.title),
        Text(task.description),
        Text(task.state.toString()),
        for (final tag in task.tags) Text(tag.title),
        for (final daylist in task.dayLists) Text(daylist.date.toString()),
      ],
    );
  }
}
