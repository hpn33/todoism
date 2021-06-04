import 'package:flutter/material.dart';

class StyledBox extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool isList;

  const StyledBox(
      {Key? key, required this.child, this.title, this.isList = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(3.0),
      child: Material(
        elevation: 1,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Material(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(title ?? ''),
                ),
              ),
            ),
            if (isList) Expanded(child: child),
            if (!isList) child,
          ],
        ),
      ),
    );
  }
}
