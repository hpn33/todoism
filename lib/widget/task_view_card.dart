import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskViewCard extends HookConsumerWidget {
  const TaskViewCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    // show title, description, tags
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        width: 200,
        height: 100,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Decription", style: TextStyle(fontSize: 13)),
            Spacer(),
            Wrap(
              children: [
                ActionChip(onPressed: () {}, label: const Text("Tag")),
                ActionChip(onPressed: () {}, label: const Text("Tag")),
                ActionChip(onPressed: () {}, label: const Text("Tag")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
