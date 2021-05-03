import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoism/page/total_view.dart';
import 'package:todoism/widget/main_frame.dart';

import 'component/add_task_form.dart';
import 'day_view.dart';
import 'tag_view.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainFrame(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TabView(),
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
  final titles = const ['total', 'days', 'tags'];

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: titles.length);

    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: titles
              .map((e) =>
                  Tab(child: Text(e, style: TextStyle(color: Colors.black))))
              .toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              TotalView(),
              DayView(),
              TagView(),
            ],
          ),
        ),
      ],
    );
  }
}
