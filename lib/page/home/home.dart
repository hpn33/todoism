import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoism/widget/main_frame.dart';

import 'view/dashboard_view.dart';
import 'view/date_view.dart';
import 'view/flag_view.dart';
import 'view/setting_view.dart';
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
    'flags': FlagView(),
    'setting': SettingView(),
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
      ],
    );
  }
}
