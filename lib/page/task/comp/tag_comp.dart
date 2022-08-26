import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/page/task/task_page.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/tag_type.dart';
import 'package:todoism/service/hive/type/task_type.dart';
import 'package:todoism/widget/autocomplete.dart';
import 'package:todoism/widget/styled_box.dart';
import 'package:hive_flutter/hive_flutter.dart';

// class TagComp extends HookWidget {
//   @override
//   Widget build(BuildContext context) {
//     final task = useProvider(TaskPage.selectedTask).state;

//     useListenable(hiveW.tags.box.listenable());
//     useListenable(hiveW.taskTagRels.box.listenable());

//     return StyledBox(
//       title: 'tags',
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Wrap(
//           children: [
//             for (final tag in task.tags)
//               Chip(
//                 label: Text(tag.title),
//                 deleteIcon: Icon(Icons.clear),
//                 onDeleted: () => task.deleteTag(tag),
//               ),
//             CompositedTransformTarget(
//               link: _layerLink,
//               child: ActionChip(
//                 label: Icon(Icons.add),
//                 onPressed: () {
//                   updateOverlayEntry(context, task);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class TagComp extends StatefulHookConsumerWidget {
  const TagComp({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TagCompState();

  // @override
  // _TagCompState createState() => _TagCompState();
}

class _TagCompState extends ConsumerState<TagComp> {
  final FocusNode _focusNode = FocusNode();

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _overlayEntry!.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final task = ref.watch(TaskPage.selectedTask.state).state;

    useListenable(hiveW.tags.box.listenable());
    useListenable(hiveW.taskTagRels.box.listenable());

    return StyledBox(
      title: 'tags',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          children: [
            for (final tag in task.tags)
              Chip(
                label: Text(tag.title),
                deleteIcon: const Icon(Icons.clear),
                onDeleted: () => task.deleteTag(tag),
              ),
            CompositedTransformTarget(
              link: _layerLink,
              child: ActionChip(
                label: const Icon(Icons.add),
                onPressed: () {
                  updateOverlayEntry(task);
                  _focusNode.requestFocus();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateOverlayEntry(Task task) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(-(offset.dx / 2), size.height - offset.dy),
          child: SizedBox(
            width: 100,
            height: 50,
            child: Material(
              elevation: 4.0,
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                    },
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AutoCompleteTextField<Tag>(
                      focusNode: _focusNode,
                      suggestions: hiveW.tags.all.toList(),
                      itemFilter: (a, b) => a.title.contains(b),
                      itemBuilder: (context, t) => Text(t.title),
                      textSubmitted: (text) {
                        task.addTag(Tag()..title = text);
                        _overlayEntry!.remove();
                      },
                      itemSubmitted: (tag) {
                        task.addTag(tag);
                        _overlayEntry!.remove();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(_overlayEntry!);
  }
}
