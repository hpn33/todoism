import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/widget/main_frame.dart';

import 'component/add_task_form.dart';
import 'component/total_task_list.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainFrame(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                TabView(),
                TotalTaskList(),
              ],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                AddTaskForm(),
                Card(
                  child: Text('Add Tag'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TabView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 3);

    return TabBar(
      controller: tabController,
      tabs: List.generate(
        tabController.length,
        (index) => Text(
          '$index',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
