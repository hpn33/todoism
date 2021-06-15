import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/task_type.dart';
import 'package:todoism/widget/main_frame.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'view/dashboard_view.dart';
import 'view/date_view.dart';
import 'view/tag_view.dart';
import 'view/todo_view.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainFrame(
      child: TabView(),
    );
  }
}

class TabView extends HookWidget {
  final views = {
    'dashboard': DashboardView(),
    'todo': TodoView(),
    'date': DateView(),
    'tags': TagView(),
  };

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: views.length);

    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: views.keys
              .map((e) =>
                  Tab(child: Text(e, style: TextStyle(color: Colors.black))))
              .toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: views.values.toList(),
          ),
        ),
        BottomComp(),
      ],
    );
  }
}

class BottomComp extends HookWidget {
  const BottomComp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasks = hiveW.tasks.all;

    useListenable(hiveW.tasks.box.listenable());
    useListenable(hiveW.taskDayListRels.box.listenable());

    return Container(
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            // status
            allStatus(tasks),
            SizedBox(width: 10),
            todayStatus(),
          ],
        ),
      ),
    );
  }

  Widget allStatus(Iterable<Task> tasks) {
    final done = tasks.where((element) => element.state == true).length;

    return Tooltip(
      message: 'All/Done/Not',
      child: Text(
        '${tasks.length}/$done/${tasks.length - done}',
      ),
    );
  }

  Widget todayStatus() {
    final tasks = hiveW.dayLists.today.tasks;
    final done = tasks.where((element) => element.state!).length;

    return Tooltip(
      message: 'Today Status',
      child: Text(
        '${tasks.length}/$done',
      ),
    );
  }
}
