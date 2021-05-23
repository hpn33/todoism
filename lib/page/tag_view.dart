import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/tag_type.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TagView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final tags = hiveW.tags.all;

    useListenable(hiveW.tags.box.listenable());

    return ListView.builder(
      itemCount: tags.length,
      itemBuilder: (context, index) => item(tags.elementAt(index)),
    );
  }

  Widget item(Tag tag) {
    return Material(
      elevation: 4,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: tag.delete,
              ),
              Text(tag.title),
            ],
          ),
        ],
      ),
    );
  }
}
