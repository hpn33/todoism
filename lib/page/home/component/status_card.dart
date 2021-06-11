import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StatusCard extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = hiveW.tasks.all;
    final done = tasks.where((element) => element.state == true);

    useListenable(hiveW.tasks.box.listenable());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            item('All', tasks.length, Colors.blue),
            item('Done', done.length, Colors.green),
            item('Not', tasks.length - done.length, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget item(String text, int number, Color color) {
    return Row(
      children: [
        Text(text),
        SizedBox(width: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: color,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Text(
            number.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
