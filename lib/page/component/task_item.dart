import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/tag_type.dart';
import 'package:todoism/service/hive/type/task_type.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoism/widget/autocomplete.dart';

final currentTask = ScopedProvider<Task>(null);

class TaskItem extends HookWidget {
  const TaskItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Material(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TitleComp(),
              SizedBox(height: 10),
              DescriptionComp(),
              SizedBox(height: 10),
              tagsBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget tagsBuilder() {
    return HookBuilder(
      builder: (BuildContext context) {
        final task = useProvider(currentTask);

        useListenable(hiveW.taskTagRels.box.listenable());

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 80),
            Wrap(
              children: [
                ...task.tags
                    .map(
                      (e) => ActionChip(
                        onPressed: () {},
                        label: Text(e.title),
                      ),
                    )
                    .toList(),
                SizedBox(
                  width: 120,
                  child: AutoCompleteTextField<Tag>(
                    suggestions: hiveW.tags.all.toList(),
                    itemFilter: (a, b) => a.title.contains(b),
                    itemBuilder: (context, t) => Text(t.title),
                    textSubmitted: (text) {
                      task.addTag(Tag()..title = text);
                    },
                    itemSubmitted: (tag) {
                      task.addTag(tag);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class TitleComp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final task = useProvider(currentTask);

    final state = useState(task.state!);

    final itemFocus = useFocusNode();
    useListenable(itemFocus);

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Focus(
      focusNode: itemFocus,
      onFocusChange: (focused) {
        if (focused) {
          textEditingController.text = task.title;
        } else {
          if (task.title != textEditingController.text) {
            task.title = textEditingController.text;
            task.save();
          }
        }
      },
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    task.delete();
                  },
                ),
                Checkbox(
                  // tristate: task.state == null ? true : false,
                  value: task.state == null ? false : task.state,
                  onChanged: (v) {
                    task.state = v;
                    task.save();

                    state.value = task.state!;
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                itemFocus.requestFocus();
                textFieldFocusNode.requestFocus();
              },
              child: itemFocus.hasFocus
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            focusNode: textFieldFocusNode,
                            controller: textEditingController,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.done),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ],
                    )
                  : Text(
                      task.title,
                      style: TextStyle(fontSize: 22),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class DescriptionComp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final task = useProvider(currentTask);

    final itemFocus = useFocusNode();
    useListenable(itemFocus);

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Focus(
      focusNode: itemFocus,
      onFocusChange: (focused) {
        if (focused) {
          textEditingController.text = task.description;
        } else {
          if (task.description != textEditingController.text) {
            task.description = textEditingController.text;
            task.save();
          }
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80),

          // content
          Expanded(
            child: GestureDetector(
              onTap: () {
                itemFocus.requestFocus();
                textFieldFocusNode.requestFocus();
              },
              child: Container(
                padding: (itemFocus.hasFocus || task.description.length > 0)
                    ? const EdgeInsets.all(8)
                    : null,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: itemFocus.hasFocus
                    ? Stack(
                        children: [
                          TextField(
                            autofocus: true,
                            focusNode: textFieldFocusNode,
                            controller: textEditingController,
                            minLines: 1,
                            maxLines: 10,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: Icon(Icons.done),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                        ],
                      )
                    : task.description.length > 0
                        ? Text(task.description)
                        : InkWell(
                            child: Icon(Icons.add, size: 18),
                          ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
