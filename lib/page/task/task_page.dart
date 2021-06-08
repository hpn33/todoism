import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/service/hive/type/task_type.dart';
import 'package:todoism/widget/main_frame.dart';
import 'package:todoism/widget/styled_box.dart';

import 'comp/daylist_comp.dart';
import 'comp/descript_comp.dart';
import 'comp/tag_comp.dart';
import 'comp/title_comp.dart';

class TaskPage extends HookWidget {
  static final selectedTask = StateProvider((ref) => Task());

  @override
  Widget build(BuildContext context) {
    return MainFrame(
      child: Container(
        color: Colors.grey[300],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(children: [BackButton()]),
                  SizedBox(height: 50),
                  TagComp(),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TitleComp(),
                  ),
                  StyledBox(
                    title: 'detail',
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DescriptionComp(),
                    ),
                  ),
                  DayListComp(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
