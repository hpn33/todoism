import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoism/page/component/task_item.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TotalView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useListenable(hiveW.tasks.box.listenable());
    final tasks = hiveW.tasks.all;

    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: tasks.map((task) => TaskItem(task: task)).toList(),
          ),
        ),
      ),
    );
  }
}
