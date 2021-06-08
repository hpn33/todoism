import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/page/task/task_page.dart';
import 'package:todoism/widget/styled_box.dart';

class TagComp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final task = useProvider(TaskPage.selectedTask).state;

    return StyledBox(
      title: 'tags',
      child: Column(
        children: [
          for (final tag in task.tags) Text(tag.title),
        ],
      ),
    );
  }
}
