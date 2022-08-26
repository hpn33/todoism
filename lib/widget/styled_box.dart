import 'package:flutter/material.dart';

class StyledBox extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool isList;

  const StyledBox({
    super.key,
    required this.child,
    this.title,
    this.isList = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(title ?? ''),
            ),
          ),
          if (isList) Expanded(child: child),
          if (!isList) child,
        ],
      ),
    );
  }
}
