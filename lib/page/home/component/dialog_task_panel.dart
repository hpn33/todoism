import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/task_type.dart';

class DialogTaskPanel extends HookConsumerWidget {
  final searchP = StateProvider((ref) => '');
  final uncompleteTasks = Provider(
    (ref) => hiveW.tasks.where((element) => element.state == false),
  );
  late final FutureProvider<Iterable<Task>> tasksProvider =
      FutureProvider<Iterable<Task>>((ref) async {
    final search = ref.watch(searchP);
    final tasks = ref.read(uncompleteTasks);

    if (search.isEmpty) {
      return tasks;
    }

    return tasks.where((element) => element.title.contains(search));
  });

  final DateTime selectedDay;

  DialogTaskPanel(this.selectedDay, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final tasks = ref.watch(tasksProvider);

    final controller = useTextEditingController();

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              onChanged: (v) {
                ref.read(searchP.state).state = v;
              },
              focusNode: FocusNode()..requestFocus(),
            ),
            Expanded(
              child: tasks.when(
                data: (tasks) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks.elementAt(index);

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 2,
                          child: InkWell(
                            onTap: () async {
                              hiveW.dayLists
                                  .submitTask(selectedDay, taskId: task.key);

                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(task.title),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
                error: (o, s) {
                  return Center(child: Text('$o\n$s'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
