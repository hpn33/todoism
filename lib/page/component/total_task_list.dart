import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/task_type.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TotalTaskList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useListenable(hiveW.tasks.box.listenable());

    return Column(
      children: hiveW.tasks.all.map((e) => item(e)).toList(),
    );
  }

  Widget item(Task task) {
    return Text(task.title);
  }
}
