import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';

import 'package:todoism/service/hive/type/tag_type.dart';
import 'package:todoism/widget/autocomplete.dart';

class AddTaskForm extends HookWidget {
  const AddTaskForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateTime = useState(
      () {
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day);
      }(),
    );
    final titleText = useTextEditingController();
    final descriptText = useTextEditingController();
    // final tagText = useTextEditingController();
    final tagList = useState(<Tag>[]);
    // final tag = useState<Tag?>(null);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Task',
                  style: TextStyle(fontSize: 22),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    hiveW.addTask(
                      titleText.text,
                      descriptText.text,
                      dateTime.value,
                      tagList.value,
                    );

                    titleText.clear();
                    descriptText.clear();
                    // tagText.clear();
                    tagList.value = [];
                  },
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    dateTime.value =
                        dateTime.value.add(const Duration(days: -1));
                  },
                  child: const Text('<'),
                ),
                TextButton(
                  child: Text(DateFormat.yMd().format(dateTime.value)),
                  onPressed: () async {
                    final time = await showDatePicker(
                      context: context,
                      initialDate: dateTime.value,
                      firstDate: DateTime.now().add(const Duration(days: -365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );

                    if (time != null) {
                      dateTime.value = time;
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    dateTime.value =
                        dateTime.value.add(const Duration(days: 1));
                  },
                  child: const Text('>'),
                ),
              ],
            ),
            const Text('Title'),
            TextField(
              controller: titleText,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const Text('Desc'),
            TextField(
              controller: descriptText,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              minLines: 3,
              maxLines: 5,
            ),
            const Text('Tags'),
            Row(
              children: [
                Expanded(
                  child: AutoCompleteTextField<Tag>(
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    suggestions: hiveW.tags.all.toList(),
                    itemSubmitted: (t) {
                      tagList.value = [...tagList.value, t];
                    },
                    textSubmitted: (t) {
                      tagList.value = [...tagList.value, Tag()..title = t];
                    },
                    itemFilter: (a, b) => a.title.contains(b),
                    itemBuilder: (context, item) => Text(item.title),
                  ),
                ),
              ],
            ),
            Wrap(
              children: tagList.value
                  .map(
                    (e) => ActionChip(
                      label: Text(e.title),
                      onPressed: () {
                        tagList.value = [...tagList.value..remove(e)];
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
