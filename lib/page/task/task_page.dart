import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/service/hive/type/task_type.dart';

import 'comp/daylist_comp.dart';
import 'comp/descript_comp.dart';
import 'comp/tag_comp.dart';
import 'comp/title_comp.dart';

class TaskPage extends HookWidget {
  static final selectedTask = StateProvider((ref) => Task());

  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 700,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Expanded(child: TitleComp()),
                    BackButton(),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: const [],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: const [
                        TagComp(),
                        DescriptionComp(),
                        DayListComp(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
