import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoism/page/task/task_page.dart';
import 'package:todoism/service/hive/hive_wrapper.dart';
import 'package:todoism/service/hive/type/tag_type.dart';
import 'package:todoism/widget/autocomplete.dart';
import 'package:todoism/widget/styled_box.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TagComp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final task = useProvider(TaskPage.selectedTask).state;

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
                deleteIcon: Icon(Icons.clear),
                onDeleted: () => task.deleteTag(tag),
              ),
            ActionChip(
              label: Icon(Icons.add),
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => TagSelector(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void updateOverlay([String? query]) {
  //   if (listSuggestionsEntry == null) {
  //     final Size textFieldSize = (context.findRenderObject() as RenderBox).size;
  //     final width = textFieldSize.width;
  //     final height = textFieldSize.height;
  //     listSuggestionsEntry = OverlayEntry(
  //       builder: (context) {
  //         return Positioned(
  //           width: width,
  //           child: CompositedTransformFollower(
  //             link: _layerLink,
  //             showWhenUnlinked: false,
  //             offset: Offset(0.0, height),
  //             child: SizedBox(
  //               width: width,
  //               child: Card(
  //                 child: Column(
  //                   children: filteredSuggestions.map(
  //                     (suggestion) {
  //                       return Row(
  //                         children: [
  //                           Expanded(
  //                             child: InkWell(
  //                               child: itemBuilder(context, suggestion),
  //                               onTap: () {
  //                                 setState(
  //                                   () {
  //                                     if (submitOnSuggestionTap) {
  //                                       String newText = suggestion.toString();
  //                                       if (textField.controller != null) {
  //                                         textField.controller!.text = newText;
  //                                       }
  //                                       if (textField.focusNode != null) {
  //                                         textField.focusNode!.unfocus();
  //                                       }
  //                                       if (itemSubmitted != null) {
  //                                         itemSubmitted!(suggestion);
  //                                       }

  //                                       if (clearOnSubmit) {
  //                                         clear();
  //                                       }
  //                                     } else {
  //                                       String newText = suggestion.toString();
  //                                       textField.controller!.text = newText;
  //                                       textChanged!(newText);
  //                                     }
  //                                   },
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //                         ],
  //                       );
  //                     },
  //                   ).toList(),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //     Overlay.of(context)!.insert(listSuggestionsEntry!);
  //   }

  //   filteredSuggestions = getSuggestions(
  //     suggestions,
  //     itemSorter,
  //     itemFilter,
  //     suggestionsAmount,
  //     query,
  //   );

  //   listSuggestionsEntry!.markNeedsBuild();
  // }

}

class TagSelector extends HookWidget {
  const TagSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final task = useProvider(TaskPage.selectedTask).state;

    return Dialog(
      child: Container(
        width: 100,
        color: Colors.white,
        child: AutoCompleteTextField<Tag>(
          suggestions: hiveW.tags.all.toList(),
          itemFilter: (a, b) => a.title.contains(b),
          itemBuilder: (context, t) => Text(t.title),
          textSubmitted: (text) {
            task.addTag(Tag()..title = text);
            Navigator.of(context).pop();
          },
          itemSubmitted: (tag) {
            task.addTag(tag);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
